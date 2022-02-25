import numpy
import sys
import mysql.connector
import matplotlib.pyplot as plt
import random
from tsmoothie.smoother import *

port = sys.argv[1]
limit = int(sys.argv[2])
max_osc = 400
n_bistables = 8



cnx = mysql.connector.connect(user='user', password='cc5XcvxY',
                              host='127.0.0.1',
                              database='PUF_CRPs')
                              
cursor = cnx.cursor()

query = (   "SELECT id FROM `PUF_runs` "
            "WHERE secube = %s AND challenge = %s "
            "ORDER BY timestamp DESC "
            "LIMIT %s"
        )


challenge = "1ADF85C26F2A79E7"
challenge = bytes.fromhex(challenge)


cursor.execute(query, (port, challenge, limit))

runs = []

for runID in cursor:
    runs.append(runID[0])


query = (   "SELECT n_occurrences FROM `PUF_results` "
            "WHERE runID = %s AND bistable = %s"
        )

n_osc = numpy.zeros((limit, n_bistables*max_osc), dtype=float)
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
    #print(len(smoother.smooth_data[0]))
    plt.plot(n_osc[k])
    

cursor.close()
cnx.close()

dist = 0
max_dist = 0
for i in range(0,len(runs)-1):
    for j in range(i+1, len(runs)):
        dist2 = numpy.linalg.norm(n_osc[i]-n_osc[j])
        dist += dist2
        max_dist = max(max_dist, dist2)
        

dist = 2*dist/(len(runs)-1)/len(runs)
print(dist)
print(max_dist)

# plt.title("Responses from 10000 runs, 4 times the same challenge")
# plt.xlabel("Number of oscillations")
# plt.ylabel("Number of occurrences")    
plt.show()