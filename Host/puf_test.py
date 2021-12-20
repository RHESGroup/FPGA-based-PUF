import serial
import numpy

import sys
import mysql.connector
import random
import threading, queue
import matplotlib.pyplot as plt

import logging
import sys
logging.basicConfig(format='%(asctime)s %(levelname)-8s %(message)s', stream=sys.stdout, level=logging.DEBUG)
logger = logging.getLogger()

max_osc = 10000
max_osc = 400
n_bistables = 8

def run_puf(port, challenge, n=1000):
    global max_osc, n_bistables
    n_osc = numpy.zeros((n_bistables, max_osc), dtype=int)
    ser = serial.Serial(port)  # open serial port
    ser.rtscts = True
    ser.baudrate = 921600    
    valid_res=0
    ser.timeout = 10
    ser.write_timeout = 10
    try:
        ser.write(b'chal' + challenge + n.to_bytes(2, 'little'))
        ser.write(b'puff')
    except e:
        ser.close()
        raise e
    for i in range(0, n_bistables):
        puf_resp = ser.read(2*max_osc)
        if(len(puf_resp) < 2*max_osc):
            ser.close()
            raise Exception('Timeout expired while reading from serial')
        for j in range(0, max_osc):
            n_osc[i][j] = int.from_bytes(puf_resp[2*j : 2*j+2], 'little')
    valid_res = numpy.sum(n_osc)
    q.put((port, challenge, valid_res, n_osc))
    ser.close()
    return valid_res
    

cnx = mysql.connector.connect(user='user', password='cc5XcvxY',
                              host='127.0.0.1',
                              database='PUF_CRPs')

q = queue.Queue()

def mysql_worker():
    global max_osc
    global cnx
    while True:
        (port, challenge, valid_res, n_osc) = q.get()
        cursor = cnx.cursor()
    
        add_run = ("INSERT INTO PUF_runs "
                   "(secube, challenge, valid_responses) "
                   "VALUES (%s, %s, %s)")
                   
        data_run = (port, challenge, int(valid_res))
        cursor.execute(add_run, data_run)
        
        run_id = cursor.lastrowid

        add_results = ("INSERT INTO PUF_results "
                    "(runID, bistable, response, n_occurrences) "
                    "VALUES (%s, %s, %s, %s)")
        
        for i in range(0, n_bistables):
            for j in range(0, max_osc):
                if (n_osc[i][j] > 0):                   
                    data_results = (run_id, i, j, int(n_osc[i][j]))
                    cursor.execute(add_results, data_results)
        
        cnx.commit()
        cursor.close()
        q.task_done()

threading.Thread(target=mysql_worker, daemon=True).start()

port = sys.argv[1]

for i in range(0,1):
    random.seed(0)                              
    for i in range(0,8):
        challenge = random.getrandbits(8 * 8).to_bytes(8, 'little')
        valid_res = 0
        while(valid_res == 0):
            logger.info("Running challenge " + challenge.hex())
            try:
                valid_res = run_puf(port, challenge, 10000)
            except Exception as e:
                cnx.rollback()
                logger.error(e)

        logger.info(str(valid_res) + " responses read successfully")    
q.join()

cnx.close()

