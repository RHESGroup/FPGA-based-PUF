import numpy
import sys
import mysql.connector
import matplotlib.pyplot as plt
import random

port = sys.argv[1]
limit = int(sys.argv[2])
max_osc = 10000

cnx = mysql.connector.connect(user='user', password='cc5XunxY',
                              host='127.0.0.1',
                              database='PUF_CRPs')
                              
cursor = cnx.cursor()

query = (   "SELECT id FROM `PUF_runs` "
            "WHERE secube = %s AND challenge = %s"
            "LIMIT %s"
        )


challenge = "13167ae8d9dceb37"
challenge = bytes.fromhex(challenge)


cursor.execute(query, (port, challenge, limit))

runs = []

for runID in cursor:
    runs.append(runID[0])


query = (   "SELECT response, n_occurrences FROM `PUF_results` "
            "WHERE runID = %s"
        )

for runID in runs:
    block_size=2
    cursor.execute(query, [runID])
    n_osc = numpy.zeros(max_osc//block_size+1, dtype=int)
    for (response, n_occurrences) in cursor:
        n_osc[response//block_size] += n_occurrences
        if (response % block_size >= block_size//2):
            n_osc[(response+block_size//2)//block_size] += n_occurrences
    plt.plot(range(0,max_osc+1,block_size), n_osc/2)
    

cursor.close()
cnx.close()

plt.title("Responses from 10000 runs, 4 times the same challenge")
plt.xlabel("Number of oscillations")
plt.ylabel("Number of occurrences")    
plt.show()