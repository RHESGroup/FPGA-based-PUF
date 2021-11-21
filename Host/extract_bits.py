import numpy
import sys
import mysql.connector
import matplotlib.pyplot as plt
import random
from sh import *


def getFeatureMatrix(runs):
    global max_osc, cursor
    block_size = 2
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

port = sys.argv[1]
limit = int(sys.argv[2])
max_osc = 200

cnx = mysql.connector.connect(user='user', password='cc5XunxY',
                              host='127.0.0.1',
                              database='PUF_CRPs')

print("Connected to database")                              
cursor = cnx.cursor()

query = (   "SELECT id FROM PUF_runs "
            "WHERE valid_responses > 5000 and secube = %s "
            "LIMIT %s"
        )

cursor.execute(query, (port, 200))

runs = []

for runID in cursor:
    runs.append(runID)


features = getFeatureMatrix(runs)
SHParam = trainSH(features, 2)

query = (   "SELECT id FROM PUF_runs "
            "WHERE secube = %s AND (challenge = %s or 1)"
            "LIMIT %s"
        )

random.seed(0)
for i in range(0,999):
    challenge = random.getrandbits(8 * 8).to_bytes(8, 'little')

cursor.execute(query, (port, challenge, limit))

del runs
runs = []

for runID in cursor:
    runs.append(runID)


features = getFeatureMatrix(runs)

print("eja")
(out, U) = compressSH(features, SHParam)

print(out)

cursor.close()
cnx.close()

# for i in range(0, limit):
#     plt.plot(range(0, max_osc), features[i])
# plt.show()