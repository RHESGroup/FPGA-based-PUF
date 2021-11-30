import numpy
import sys
import mysql.connector
import matplotlib.pyplot as plt
import random
from sh import *
from hamming import *

port = sys.argv[1]
max_osc = 400

cnx = mysql.connector.connect(user='user', password='cc5XunxY',
                              host='127.0.0.1',
                              database='PUF_CRPs')

print("Connected to database")                              
cursor = cnx.cursor()


def getFeatureMatrix(runs):
    global max_osc, cursor
    block_size = 2
    query = (   "SELECT response, n_occurrences FROM PUF_results "
                "WHERE runID = %s"
            )

    features = numpy.zeros((len(runs), max_osc), dtype=int)
    i = 0
    for runID in runs:
        cursor.execute(query, [runID])
        n_osc = numpy.zeros(max_osc, dtype=int)
        for (response, n_occurrences) in cursor:
            if (response < (max_osc-1)*block_size):
                features[i][response//block_size] += n_occurrences
                if (response % block_size >= block_size//2):
                    n_osc[(response+block_size//2)//block_size] += n_occurrences
        i+=1
    return features

def trainSHDevice(port):
    query = (   "SELECT min(id) FROM PUF_runs "
                "WHERE valid_responses > 3000 and secube = %s "
                "GROUP BY challenge"           
            )

    cursor.execute(query, [port])

    runs = []

    for runID in cursor:
        runs.append(runID[0])


    features = getFeatureMatrix(runs)
    SHParam = trainSH(features, 8)
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

    query = (   "SELECT DISTINCT secube FROM PUF_runs"
    )

    cursor.execute(query)
    ports = cursor.fetchall()

    SHParams = {}

    for port in ports:
        port = port[0]
        SHParams[port] = trainSHDevice(port)

    query = (   "SELECT DISTINCT challenge FROM PUF_runs "
            "WHERE secube = %s AND valid_responses > 3000 "
            "LIMIT 100"
        )

    cursor.execute(query, [port])

    challenges = []
    for challenge in cursor:
        challenges.append(challenge[0])

    query = (   "SELECT MAX(id), secube FROM PUF_runs "
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

    query = (   "SELECT max(id) FROM PUF_runs "
                "WHERE secube = %s AND valid_responses > 3000 "
                "GROUP BY challenge "
        )

    interChallengeDist=0

    cursor.execute(query, [port])
    runs = []

    for runID in cursor:
        runs.append(runID[0])

    features = getFeatureMatrix(runs)
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
    query = (   "SELECT DISTINCT challenge FROM PUF_runs "
            "WHERE secube = %s AND valid_responses > 3000 "
            "LIMIT 100"
        )

    cursor.execute(query, [port])

    challenges = []
    for challenge in cursor:
        challenges.append(challenge[0])

    query = (   "SELECT id FROM PUF_runs "
                "WHERE secube = %s AND challenge = %s AND valid_responses > 3000 "
        )

    intraDist=0

    for challenge in challenges:
        cursor.execute(query, (port, challenge))
        runs = []

        for runID in cursor:
           runs.append(runID[0])

        features = getFeatureMatrix(runs)
        (resps, U) = compressSH(features, SHParam)

        #Compute nominal response by majority voting
        nominalResp = np.sum(resps,axis=0)
        for i in range(0, len(nominalResp)):
            if(nominalResp[i]>len(resps)//2):
                nominalResp[i]=1
            else:
                nominalResp[i]=0

        for resp in resps:
            intraDist += hammingDist(nominalResp, resp)

    intraDist = intraDist/len(resp)/len(resps)/len(challenges)
    return intraDist



SHParam = trainSHDevice(port)


intraDist = computeIntraDist(port, SHParam)
print("Reliability = " + str(100-intraDist*100) + " %")
# intraUniqueness = computeIntraUniqueness(port, SHParam)
# print("Inter challenge distance = " + str(intraUniqueness*100) + " %")

# interDeviceDist =  computeInterUniqueness()
# print("Inter device distance = " + str(interDeviceDist*100) + " %")
cursor.close()
cnx.close()