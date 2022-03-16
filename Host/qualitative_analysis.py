import numpy
import sys
import mysql.connector
import matplotlib.pyplot as plt
import random
import pickle
import os
from tsmoothie.smoother import *


max_osc = 400
plot = True
loadFromFile = True
saveToFile = False #dangerous!! backup before setting it True

cnx = mysql.connector.connect(user='user', password='cc5XcvxY',
                              host='127.0.0.1',
                              database='PUF_CRPs')
                              
cursor = cnx.cursor()

def get_nosc(limit, n_bistables = 8, secube = None, challenge=None, filtr = True):
    global cursor
    if (challenge is None):
        query = (   "SELECT MIN(id) FROM `PUF_runs` "
            "WHERE secube = %s "
            "GROUP BY challenge "
            "LIMIT %s"
        )
        
        cursor.execute(query, (secube, limit))
    elif (secube is None):
        query = (   "SELECT MIN(id) FROM `PUF_runs` "
            "WHERE challenge = %s "
            "GROUP BY secube "
            "LIMIT %s"
        )
        challenge = bytes.fromhex(challenge)
        cursor.execute(query, (challenge, limit))
        
    else:
        query = (   "SELECT id FROM `PUF_runs` "
                    "WHERE secube = %s AND challenge = %s "
                    "ORDER BY timestamp DESC "
                    "LIMIT %s"
                )

        challenge = bytes.fromhex(challenge)
        cursor.execute(query, (secube, challenge, limit))

    runs = []

    for runID in cursor:
        runs.append(runID[0])


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
        if (filtr == True):
            smoother = ConvolutionSmoother(window_len=16, window_type='hamming')
            smoother.smooth(n_osc[k])
            n_osc[k] = smoother.smooth_data[0]
        #print(len(smoother.smooth_data[0]))
        
    return n_osc;


def computeDistanceDistribution(n_osc):        
    dist = []
    max_dist = 0
    for i in range(0,len(n_osc)-1):
        for j in range(i+1, len(n_osc)):
            dist2 = numpy.linalg.norm(n_osc[i]-n_osc[j])
            dist.append(dist2)           
    return dist        

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

def loadDistanceDistribution(filename):
    with open(filename, "rb") as dist_file:
            dist = pickle.load(dist_file)
            dist_file.close()
    return dist

# Retrieve challenges set
query = "SELECT DISTINCT(HEX(challenge)) FROM PUF_runs"
cursor.execute(query)

challenges = []
for challenge in cursor:
    challenges.append(challenge[0])


port = sys.argv[1]
figNumber = 1

# Plot of a single distribution of a single bistable, no filter
plt.figure(figNumber)
figNumber+=1
n_osc = get_nosc(1, 1, secube = port, challenge = "FEC12AB6EFE0634B", filtr = False)

for n_osc_run in n_osc:
    plt.plot(n_osc_run)

plt.xlabel("Number of oscillations")
plt.ylabel("Probability")
plt.grid()




# Plot of a single distribution of a single bistable
plt.figure(figNumber)
figNumber+=1
n_osc = get_nosc(1, 1, secube = port, challenge = "FEC12AB6EFE0634B")

for n_osc_run in n_osc:
    plt.plot(n_osc_run)

plt.xlabel("Number of oscillations")
plt.ylabel("Probability")
plt.grid()



# Plot of 4 times the distribution of a single bistable, 4 different challenges.
plt.figure(figNumber)
figNumber+=1
n_osc = get_nosc(4, 1, secube = port)

for n_osc_run in n_osc:
    plt.plot(n_osc_run)

plt.xlabel("Number of oscillations")
plt.ylabel("Probability")    
plt.grid()

# Plot of 4 times the distribution of a single bistable, same challenges, different devices.
plt.figure(figNumber)
figNumber+=1
n_osc = get_nosc(4, 1, challenge = "1BCCCEA696762E61")

for n_osc_run in n_osc:
    plt.plot(n_osc_run)

plt.xlabel("Number of oscillations")
plt.ylabel("Probability")    
plt.grid()


# Plot of 4 times the distribution of a single bistable, 4 times the same challenge.
plt.figure(figNumber)
figNumber+=1
n_osc = get_nosc(4, 1, secube = port, challenge = "FEC12AB6EFE0634B")

for n_osc_run in n_osc:
    plt.plot(n_osc_run)

plt.xlabel("Number of oscillations")
plt.ylabel("Probability")    
plt.grid()

print(numpy.linalg.norm(n_osc[0]-n_osc[1]))

# Plot of 2 distributions of 8 bistables, same challenge
plt.figure(figNumber)
figNumber+=1
n_osc = get_nosc(2, 8, secube = port, challenge = "FEC12AB6EFE0634B")

for n_osc_run in n_osc:
    plt.plot(n_osc_run)

plt.xlabel("Coordinate index")
plt.ylabel("Value")
plt.grid()

print(numpy.linalg.norm(n_osc[0]-n_osc[1]))

# Plot of 2 distributions of 8 bistables, different challenges
plt.figure(figNumber)
figNumber+=1
n_osc = get_nosc(2, 8, secube = port)

for n_osc_run in n_osc:
    plt.plot(n_osc_run)

plt.xlabel("Coordinate index")
plt.ylabel("Value")
plt.grid()

#Intra/Inter distance comparison
plt.figure(figNumber)
figNumber+=1

if (loadFromFile):
    dist = loadDistanceDistribution("n_osc_dist/n_osc_intradist_" + port+ ".dat")
elif(saveToFile):
    dist = []
    for challenge in challenges:
        print(challenge)
        n_osc = get_nosc(10, 1, secube = port, challenge = challenge)
        dist.extend(computeDistanceDistribution(n_osc))

    os.makedirs("n_osc_dist", exist_ok = True)    
    with open("n_osc_dist/n_osc_intradist_" + port+ ".dat", "wb") as dist_file:
        pickle.dump(dist, dist_file)
        dist_file.close()

intra_dist, bins, _ = plt.hist(dist, bins=numpy.linspace(0,1,200), density=True, histtype='step', label= 'Intra-distance')

if (loadFromFile):
    dist = loadDistanceDistribution("n_osc_dist/n_osc_inter_challenge_dist_" + port+ ".dat")
elif(saveToFile):
    n_osc = get_nosc(2000, 1, secube = port)
    dist = computeDistanceDistribution(n_osc)
    with open("n_osc_dist/n_osc_inter_challenge_dist_" + port+ ".dat", "wb") as dist_file:
        pickle.dump(dist, dist_file)
        dist_file.close()

inter_challenge_dist, bins, _ = plt.hist(dist, bins=numpy.linspace(0,1,200), density=True, histtype='step', label= 'Inter-challenge distance')


if (loadFromFile):
    dist = loadDistanceDistribution("n_osc_dist/n_osc_inter_device_dist_" + port+ ".dat")
elif(saveToFile):
    dist = []
    i = 0
    for challenge in challenges:
        print(str(i*100/2000) + "%",end="\r")
        n_osc = get_nosc(100, 1, challenge = challenge)
        dist.extend(computeDistanceDistribution(n_osc))
        i +=1
        
    with open("n_osc_dist/n_osc_inter_device_dist_" + port + ".dat", "wb") as dist_file:
        pickle.dump(dist, dist_file)
        dist_file.close()

inter_device_dist, bins, _ = plt.hist(dist, bins=numpy.linspace(0,1,200), density=True, histtype='step', label= 'Inter-device distance')


plt.legend()

plt.xlabel("Euclidean Distance")
plt.ylabel("Probability density")    
plt.grid()

#Intra/Inter distance comparison 1 bistable
figNumber+=1
plt.figure(figNumber)

dist = loadDistanceDistribution("n_osc_dist/1-bistable/n_osc_intradist_" + port+ ".dat")
intra_dist_1_bist, bins, _ = plt.hist(dist, bins=numpy.linspace(0,1,200), density=True, histtype='step', label= 'Intra-distance')
dist = loadDistanceDistribution("n_osc_dist/1-bistable/n_osc_inter_challenge_dist_" + port+ ".dat")
inter_challenge_dist_1_bist, bins, _ = plt.hist(dist, bins=numpy.linspace(0,1,200), density=True, histtype='step', label= 'Intra-distance')


# FAR vs FRR pareto diagram
figNumber+=1
plt.figure(figNumber)

FAR = []
FRR = []
for i in range(40,101):
    FRR.append(sum(numpy.diff(bins)[i:-1]*intra_dist[i:-1]*100))
    FAR.append(sum(numpy.diff(bins)[0:i]*inter_challenge_dist[0:i]*100))


plt.plot(FAR,FRR, label="8 Bistable Rings")

FAR = []
FRR = []
for i in range(0,60):
    FRR.append(sum(numpy.diff(bins)[i:-1]*intra_dist_1_bist[i:-1]*100))
    FAR.append(sum(numpy.diff(bins)[0:i]*inter_challenge_dist_1_bist[0:i]*100))

plt.plot(FAR,FRR,label="1 Bistable Ring")


plt.xlabel("FAR [%]")
plt.ylabel("FRR [%]")
plt.grid()
plt.legend()

cursor.close()
cnx.close()


if (plot == True):
    plt.show()

