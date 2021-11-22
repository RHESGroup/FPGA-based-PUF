import numpy
import sys
import mysql.connector
import matplotlib.pyplot as plt
import random
from sh import *
from hamming import *


def getFeatureMatrix(runs):
    global max_osc, cursor
    block_size = 4
    query = (   "SELECT response, n_occurrences FROM PUF_results "
                "WHERE runID = %s"
            )

    features = numpy.zeros((len(runs), max_osc), dtype=int)
    i = 0
    for runID in runs:
        cursor.execute(query, runID)
        n_osc = numpy.zeros(max_osc, dtype=int)
        for (response, n_occurrences) in cursor:
            if (response < (max_osc-1)*block_size):
                features[i][response//block_size] += n_occurrences
                if (response % block_size >= block_size//2):
                    n_osc[(response+block_size//2)//block_size] += n_occurrences
        i+=1
    return features

def hammingDist(b1, b2):
    hd = 0
    for i in range (0, len(b1)):
        if (b1[i] != b2[i]):
            hd+=1
    return hd


def intraUniqueness(port):
    global max_osc, cursor, SHParam

    query = (   "SELECT max(id) FROM PUF_runs "
                "WHERE secube = %s AND valid_responses > 5000 "
                "GROUP BY challenge "
                "LIMIT 100" 
        )

    intraDist=0

    cursor.execute(query, [port])
    runs = []

    for runID in cursor:
        runs.append(runID)

    features = getFeatureMatrix(runs)
    (resps, U) = compressSH(features, SHParam)

    k = len(resps)
    n = len(resps[0])


    for i in range(0, k-1):
        for j in range(i+1, k):
            intraDist += hammingDist(resps[i], resps[j])

    intraDist = 2*intraDist/k/(k-1)/n*100
    print(str(intraDist) + " %")

def intraDist(port):
    global max_osc, cursor, SHParam
    query = (   "SELECT DISTINCT challenge FROM PUF_runs "
            "WHERE secube = %s AND valid_responses > 5000 "
            "LIMIT 10"
        )

    cursor.execute(query, [port])

    challenges = []
    for challenge in cursor:
        challenges.append(challenge[0])

    query = (   "SELECT id FROM PUF_runs "
                "WHERE secube = %s AND challenge = %s AND valid_responses > 5000 "
        )

    intraDist=0

    for challenge in challenges:
        cursor.execute(query, (port, challenge))
        runs = []

        for runID in cursor:
           runs.append(runID)

        features = getFeatureMatrix(runs)
        (resps, U) = compressSH(features, SHParam)

        #Compute nominal response by majority voting
        nominalResp = np.sum(resps,axis=0)
        for i in range(0, len(nominalResp)):
            if(nominalResp[i]>len(resps)//2):
                nominalResp[i]=1
            else:
                nominalResp[i]=0

        print(nominalResp)
        print(resps)
        for resp in resps:
            intraDist += hammingDist(nominalResp, resp)

    intraDist = intraDist/len(resp)/len(resps)/len(challenges)*100
    print(str(intraDist) + " %")

port = sys.argv[1]
max_osc = 200

cnx = mysql.connector.connect(user='user', password='cc5XunxY',
                              host='127.0.0.1',
                              database='PUF_CRPs')

print("Connected to database")                              
cursor = cnx.cursor()

query = (   "SELECT min(id) FROM PUF_runs "
            "WHERE valid_responses > 5000 and secube = %s "
            "GROUP BY challenge"           
        )

cursor.execute(query, [port])

runs = []

for runID in cursor:
    runs.append(runID)


features = getFeatureMatrix(runs)
SHParam = trainSH(features, 5)

intraDist(port)
intraUniqueness(port)

cursor.close()
cnx.close()

# for i in range(0, limit):
#     plt.plot(range(0, max_osc), features[i])
# plt.show()