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

query = (   "SELECT id FROM PUF_runs "
            "WHERE secube = %s "#AND challenge = %s"
            "LIMIT %s"
        )

random.seed(0)
for i in range(0,404):
    challenge = random.getrandbits(8 * 8).to_bytes(8, 'little')


cursor.execute(query, (port, limit))#challenge, limit))

runs = []

for runID in cursor:
    runs.append(runID)

query = (   "SELECT response, n_occurrences FROM PUF_results "
            "WHERE runID = %s"
        )

for runID in runs:
    block_size=2
    cursor.execute(query, runID)
    n_osc = numpy.zeros(max_osc//block_size, dtype=int)
    for (response, n_occurrences) in cursor:
        n_osc[response//block_size] += n_occurrences
        if (response % block_size >= block_size//2):
            n_osc[(response+block_size//2)//block_size] += n_occurrences
    plt.plot(range(0,max_osc,block_size), n_osc)
    

cursor.close()
cnx.close()
    
plt.show()