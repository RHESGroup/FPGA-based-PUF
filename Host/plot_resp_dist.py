import numpy
import sys
import mysql.connector
import matplotlib.pyplot as plt


port = sys.argv[1]
limit = int(sys.argv[2])
max_osc = 10000

cnx = mysql.connector.connect(user='user', password='cc5XunxY',
                              host='127.0.0.1',
                              database='PUF_CRPs')
                              
cursor = cnx.cursor()

query = (   "SELECT id FROM PUF_runs "
            "WHERE secube = %s "
            "LIMIT %s"
        )


cursor.execute(query, (port, limit))

runs = []

for runID in cursor:
    runs.append(runID)

query = (   "SELECT response, n_occurrences FROM PUF_results "
            "WHERE runID = %s"
        )

for runID in runs:
    cursor.execute(query, runID)
    n_osc = numpy.zeros(max_osc, dtype=int)
    for (response, n_occurrences) in cursor:
        n_osc[response] = n_occurrences
    plt.plot(range(0,max_osc), n_osc)
    

cursor.close()
cnx.close()
    
plt.show()