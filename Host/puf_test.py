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
    n_osc = []
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
        n_osc.append(puf_resp)
    q.put((port, challenge, valid_res, n_osc))
    ser.close()
    return 1
    

ser = serial.Serial("/dev/ttyUSB1")  # open serial port
ser.rtscts = True
ser.baudrate = 921600    
valid_res=0
ser.timeout = 10
ser.write_timeout = 10

ser.write(b'seri')
serial_number = ser.read(12)
print(serial_number)

exit()

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
                   "(secube, challenge) "
                   "VALUES (%s, %s)")
                   
        data_run = (port, challenge)
        cursor.execute(add_run, data_run)
        
        run_id = cursor.lastrowid

        add_results = ("INSERT INTO PUF_results "
                    "(runID, bistable, n_occurrences) "
                    "VALUES (%s, %s, %s)")
        
        for i in range(0, n_bistables):                 
            data_results = (run_id, i, n_osc[i])
            cursor.execute(add_results, data_results)
        
        cnx.commit()
        cursor.close()
        q.task_done()

threading.Thread(target=mysql_worker, daemon=True).start()

port = sys.argv[1]

for i in range(0,100):
    random.seed(0)                              
    for i in range(0,2000):
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

