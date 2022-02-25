import numpy
import sys
import mysql.connector
import random
import matplotlib.pyplot as plt
from sh import *
from hamming import *
from tsmoothie.smoother import *


port = sys.argv[1]
max_osc = 400
n_bistables = 8

runs_table = "`PUF_runs_2022-01-27`"
results_table = "`PUF_results_2022-01-27`"

cnx = mysql.connector.connect(user='user', password='cc5XcvxY',
                              host='127.0.0.1',
                              database='PUF_CRPs')

print("Connected to database")                              
cursor = cnx.cursor()

def get_responses(runs):
    global max_osc, cursor, n_bistables

    query = (   "SELECT n_occurrences FROM " + results_table + " "
            "WHERE runID = %s AND bistable = %s"
        )
    n_osc = numpy.zeros((len(runs), n_bistables*max_osc), dtype=float)
    for k in range(0,len(runs)):
        runID = runs[k]
        n_osc_bistable = numpy.zeros(max_osc, dtype=int)
        for i in range(0, n_bistables):
            cursor.execute(query, (runID,i) )
            n_occurrences = cursor.fetchall()
            n_occurrences = n_occurrences[0][0]
            for j in range(0, max_osc):
                n_osc_bistable[j] = int.from_bytes(n_occurrences[2*j : 2*j+2], 'little')
            n_osc[k][max_osc*i:max_osc*(i+1)] = n_osc_bistable.astype(float)/sum(n_osc_bistable)
        smoother = ConvolutionSmoother(window_len=16, window_type='bartlett')
        smoother.smooth(n_osc[k])
        n_osc[k] = smoother.smooth_data[0]
    return n_osc

def trainSHDevice(port):
    query = (   "SELECT min(id) FROM " + runs_table + " "
                "WHERE secube = %s "
                "GROUP BY challenge "
                "LIMIT 1000"           
            )

    cursor.execute(query, [port])

    runs = []
    for runID in cursor:
        runs.append(runID[0])

    features = get_responses(runs)
    print(len(features))
    SHParam = trainSH(features, 4)
    return SHParam

def hammingDist(b1, b2):
    hd = 0
    for i in range (0, len(b1)):
        if (b1[i] != b2[i]):
            hd+=1
    return hd

def computeInterUniqueness():
    global cursor, max_osc
    SHParams = []

    query = (   "SELECT DISTINCT secube FROM " + runs_table
    )

    cursor.execute(query)
    ports = cursor.fetchall()

    SHParams = {}

    for port in ports:
        port = port[0]
        SHParams[port] = trainSHDevice(port)

    query = (   "SELECT DISTINCT challenge FROM " + runs_table + " "
            "WHERE secube = %s AND valid_responses > 3000 "
            "LIMIT 100"
        )

    cursor.execute(query, [port])

    challenges = []
    for challenge in cursor:
        challenges.append(challenge[0])

    query = (   "SELECT MAX(id), secube FROM " + runs_table + " "
                "WHERE challenge = %s AND valid_responses > 3000 "
                "GROUP BY secube "
        )

    interDeviceDist = 0

    for challenge in challenges:
        cursor.execute(query, [challenge])
        runs = []
        resps = []
        runs = cursor.fetchall()

        for run in runs:
            features = getFeatureMatrix([run[0]])
            (resp, U) = compressSH(features, SHParams[run[1]])
            resps.append(resp[0])

        k = len(resps)
        n = len(resps[0])

        for i in range(0, k-1):
            for j in range(i+1, k):
                interDeviceDist += hammingDist(resps[i], resps[j])

    interDeviceDist = 2*interDeviceDist/k/(k-1)/n/len(challenges)
    return interDeviceDist

    

def computeIntraUniqueness(port, SHParam):
    global max_osc, cursor

    query = (   "SELECT max(id) FROM " + runs_table + " "
                "WHERE secube = %s "
                "GROUP BY challenge "
                "LIMIT 1000"
        )

    interChallengeDist=0

    cursor.execute(query, [port])
    runs = []

    for runID in cursor:
        runs.append(runID[0])

    features = get_responses(runs)
    (resps, U) = compressSH(features, SHParam)

    k = len(resps)
    n = len(resps[0])


    for i in range(0, k-1):
        for j in range(i+1, k):
            interChallengeDist += hammingDist(resps[i], resps[j])

    interChallengeDist = 2*interChallengeDist/k/(k-1)/n
    return interChallengeDist
    

def computeIntraDist(port, SHParam):
    global max_osc, cursor
    query = (   "SELECT DISTINCT challenge FROM " + runs_table + " "
            "WHERE secube = %s "
            "LIMIT 100"
        )

    cursor.execute(query, [port])

    challenges = []
    for challenge in cursor:
        challenges.append(challenge[0])

    query = (   "SELECT id FROM " + runs_table + " "
                "WHERE secube = %s AND challenge = %s "
                "ORDER BY timestamp ASC "
                "LIMIT 100"
                
        )

    intraDistList = []

    for challenge in challenges:
        cursor.execute(query, (port, challenge))
        runs = []
        
        intraDist=0

        for runID in cursor:
           runs.append(runID[0])

        features = get_responses(runs)
        (resps, U) = compressSH(features, SHParam)


        #Compute nominal response by majority voting
        nominalResp = np.sum(resps,axis=0)
        print(challenge.hex())
        print(nominalResp)
        for i in range(0, len(nominalResp)):
            if(nominalResp[i]>len(resps)//2):
                nominalResp[i]=1
            else:
                nominalResp[i]=0


        for resp in resps:
            intraDist += hammingDist(nominalResp, resp)

        intraDist = intraDist/len(resp)/len(resps)
        
        #if(intraDist < 0.05):
        intraDistList.append(intraDist)
        
    return intraDistList



SHParam = trainSHDevice(port)
print(SHParam)

intraDistList = computeIntraDist(port, SHParam)
plt.hist(intraDistList, density=True, bins=100)


print("Reliability = " + str(100-numpy.average(intraDistList)*100) + " %")
intraUniqueness = computeIntraUniqueness(port, SHParam)
print("Inter challenge distance = " + str(intraUniqueness*100) + " %")

# interDeviceDist =  computeInterUniqueness()
# print("Inter device distance = " + str(interDeviceDist*100) + " %")
cursor.close()
cnx.close()

plt.show()