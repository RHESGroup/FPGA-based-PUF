import numpy
import sys
import mysql.connector
import matplotlib.pyplot as plt
import random
from tsmoothie.smoother import *


max_osc = 400


cnx = mysql.connector.connect(user='user', password='cc5XcvxY',
                              host='127.0.0.1',
                              database='PUF_CRPs')
                              
cursor = cnx.cursor()

def get_nosc(secube, limit, n_bistables = 8, challenge=None, filtr = True):
    global cursor
    if (challenge is None):
        query = (   "SELECT id FROM `PUF_runs` "
            "WHERE secube = %s "
            "ORDER BY timestamp DESC "
            "LIMIT %s"
        )
        
        cursor.execute(query, (port, limit))
    else:
        query = (   "SELECT id FROM `PUF_runs` "
                    "WHERE secube = %s AND challenge = %s "
                    "ORDER BY timestamp DESC "
                    "LIMIT %s"
                )

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
            n_osc[k][max_osc*i:max_osc*(i+1)] = n_osc_bistable.astype(float)#/sum(n_osc_bistable)
        if (filtr == True):
            smoother = ConvolutionSmoother(window_len=16, window_type='hamming')
            smoother.smooth(n_osc[k])
            n_osc[k] = smoother.smooth_data[0]
        #print(len(smoother.smooth_data[0]))
        
    return n_osc;
        

def computeAvgDist(n_osc):        
    dist = 0
    max_dist = 0
    for i in range(0,len(n_osc)-1):
        for j in range(i+1, len(n_osc)):
            dist2 = numpy.linalg.norm(n_osc[i]-n_osc[j])
            dist += dist2
            max_dist = max(max_dist, dist2)           
    dist = 2*dist/(len(n_osc)-1)/len(n_osc)
    return dist




port = sys.argv[1]
figNumber = 1

# Plot of a single distribution of a single bistable, no filter
plt.figure(figNumber)
figNumber+=1
n_osc = get_nosc(port, 1, 1, challenge = "C4BB86C3D1C42710", filtr = False)

for n_osc_run in n_osc:
    plt.plot(n_osc_run)

plt.xlabel("Number of oscillations")
plt.ylabel("Number of occurrences")




# Plot of a single distribution of a single bistable
plt.figure(figNumber)
figNumber+=1
n_osc = get_nosc(port, 1, 1, "C4BB86C3D1C42710")

for n_osc_run in n_osc:
    plt.plot(n_osc_run)

plt.xlabel("Number of oscillations")
plt.ylabel("Number of occurrences")




# Plot of 4 times the distribution of a single bistable, 4 different challenges.
plt.figure(figNumber)
figNumber+=1
n_osc = get_nosc(port, 4, 1)

for n_osc_run in n_osc:
    plt.plot(n_osc_run)

plt.xlabel("Number of oscillations")
plt.ylabel("Number of occurrences")    



# Plot of 4 times the distribution of a single bistable, 4 times the same challenge.
plt.figure(figNumber)
figNumber+=1
n_osc = get_nosc(port, 4, 1, "C4BB86C3D1C42710")

for n_osc_run in n_osc:
    plt.plot(n_osc_run)

plt.xlabel("Number of oscillations")
plt.ylabel("Number of occurrences")    


cursor.close()
cnx.close()




plt.show()

