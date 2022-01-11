import numpy
import sys
import mysql.connector
import matplotlib.pyplot as plt
import random

port = sys.argv[1]
limit = int(sys.argv[2])
max_osc = 400
n_bistables = 8



cnx = mysql.connector.connect(user='user', password='cc5XcvxY',
                              host='127.0.0.1',
                              database='PUF_CRPs')
                              
cursor = cnx.cursor()

query = (   "SELECT id FROM `PUF_runs` "
            "WHERE secube = %s "# AND challenge = %s "
            "ORDER BY timestamp DESC "
            "LIMIT %s"
        )


challenge = "CD072CD8BE6F9F62"
challenge = bytes.fromhex(challenge)


cursor.execute(query, (port, limit))#challenge, limit))

runs = []

for runID in cursor:
    runs.append(runID[0])


query = (   "SELECT n_occurrences FROM `PUF_results` "
            "WHERE runID = %s AND bistable = %s"
        )

for runID in runs:
    n_osc = numpy.zeros(n_bistables*max_osc, dtype=int)
    for i in range(0, n_bistables):
        cursor.execute(query, (runID,i) )
        n_occurrences = cursor.fetchall()
        n_occurrences = n_occurrences[0][0]
        for j in range(0, max_osc):
            n_osc[max_osc*i+j] = int.from_bytes(n_occurrences[2*j : 2*j+2], 'little')
    plt.plot(range(0,n_bistables*max_osc), n_osc)
    

cursor.close()
cnx.close()

plt.title("Responses from 10000 runs, 4 times the same challenge")
plt.xlabel("Number of oscillations")
plt.ylabel("Number of occurrences")    
plt.show()