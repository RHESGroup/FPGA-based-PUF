import numpy
import sys
import mysql.connector
import pickle
from sh import *
from hamming import *
from tsmoothie.smoother import *

device = sys.argv[1]
n_bits = int(sys.argv[2])
max_osc = 400
n_bistables = 8

os.makedirs("trained", exist_ok=True)

cnx = mysql.connector.connect(user='user', password='cc5XcvxY',
                              host='127.0.0.1',
                              database='PUF_CRPs')

print("Connected to database")                              
cursor = cnx.cursor()

def get_responses(runs):
    global max_osc, cursor, n_bistables

    query = (   "SELECT n_occurrences FROM `PUF_results` "
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

def trainSHDevice(device):
    query = (   "SELECT min(id) FROM PUF_runs "
                "WHERE secube = %s "
                "GROUP BY challenge "
                "LIMIT 500"           
            )

    cursor.execute(query, [device])

    runs = []

    for runID in cursor:
        runs.append(runID[0])


    features = get_responses(runs)
    SHParam = trainSH(features, n_bits)
    return SHParam

SHParam = trainSHDevice(device)

output = open("trained/" + device + "_" + str(n_bits) + ".pkl", 'wb')
pickle.dump(SHParam,output)
output.close()