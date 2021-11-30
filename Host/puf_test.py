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

def run_puf(port, challenge, n=1000):
    global max_osc
    n_osc = numpy.zeros(max_osc, dtype=int)
    ser = serial.Serial(port)  # open serial port
    ser.rtscts = True
    ser.baudrate = 921600    
    valid_res=0
    ser.timeout = 1
    ser.write_timeout = 1
    ser.write(b'chal' + challenge + n.to_bytes(2, 'little'))
    ser.write(b'puff')
    for i in range(0, n):
        puf_resp = ser.read(8)
        if(len(puf_resp) < 8):
            raise Exception('Timeout expired while reading from serial')
        final_value = int.from_bytes(puf_resp[0:4], 'little')
        result = int.from_bytes(puf_resp[4:6], 'little')
        if ((final_value == 0xAAAAAAAA or final_value == 0x55555555) and result < max_osc):
            valid_res+=1;    
            n_osc[result] += 1
    ser.close()
    
    return n_osc, valid_res 
    

cnx = mysql.connector.connect(user='user', password='cc5XunxY',
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
                   
        data_run = (port, challenge, valid_res)
        cursor.execute(add_run, data_run)
        
        run_id = cursor.lastrowid
        
        for i in range(0, max_osc):
            if (n_osc[i] > 0):
                add_results = ("INSERT INTO PUF_results "
                   "(runID, response, n_occurrences) "
                   "VALUES (%s, %s, %s)")
                   
                data_results = (run_id, i, int(n_osc[i]))
                cursor.execute(add_results, data_results)
        
        cnx.commit()
        cursor.close()
        q.task_done()

threading.Thread(target=mysql_worker, daemon=True).start()

port = sys.argv[1]

for i in range(0,100):
    random.seed(0)                              
    for i in range(0,200):
        challenge = random.getrandbits(8 * 8).to_bytes(8, 'little')
        valid_res=0
        while(valid_res == 0):
            logger.info("Running challenge " + challenge.hex())
            try:
                (n_osc, valid_res) = run_puf(port, challenge, 10000)
            except Exception as e:
                logger.error(e)
        logger.info(str(valid_res) + " responses read successfully")
        q.put((port, challenge, valid_res, n_osc))
        #n_osc, valid_res = run_puf(sys.argv[1], challenge, cnx, 10000)
        #n_osc = n_osc/valid_res
        #print("Valid results1: " + str(valid_res))
        #plt.plot(range(0,10000), n_osc)

q.join()

cnx.close()

#plt.show()

# challenge = [65, 65, 3, 0, 65, 65, 65, 65]
# challenge2 = [0, 0xaa, 0xff, 0xff, 0xff, 1, 0, 0]
# n_osc, valid_res = run_puf(sys.argv[1], challenge, cnx, 10000)
# n_osc = n_osc/valid_res
# n_osc2, valid_res2 = run_puf(sys.argv[1], challenge2, cnx, 10000)
# n_osc2 = n_osc2/valid_res2



# dist = numpy.linalg.norm(n_osc-n_osc2)
# print("Valid results1: " + str(valid_res))
# print("Valid results2: " + str(valid_res2))
# print("Distance: " + str(dist))
# plt.plot(range(0,10000), n_osc)
# plt.plot(range(0,10000), n_osc2)
# plt.show()
