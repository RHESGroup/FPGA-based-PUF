import serial
import numpy

import sys
import mysql.connector
import random
import threading, queue
import matplotlib.pyplot as plt

max_osc = 400
block_size=2
n_bistables = 8


def run_puf(port, challenge, n=1000):
    global max_osc, block_size
    ser = serial.Serial(port)  # open serial port
    ser.rtscts = True
    ser.baudrate = 921600
    n_osc = numpy.zeros(n_bistables*max_osc, dtype=int)    
    
    ser.timeout = 10
    ser.write_timeout = 10
    ser.write(b'chal' + challenge + n.to_bytes(2, 'little'))
    ser.write(b'puff')
    puf_resp = ser.read(2*n_bistables*max_osc)
    if(len(puf_resp) < 2*n_bistables*max_osc):
            raise Exception('Timeout expired while reading from serial')
    for i in range(0, n_bistables*max_osc):
        n_osc[i] = int.from_bytes(puf_resp[2*i : 2*i+2], 'little')
        
    ser.close()
    valid_res=sum(n_osc)
    return n_osc, valid_res 
    
    
    
    return n_osc, valid_res, final_result_count
    


port = sys.argv[1]

#for i in range(0,10):
random.seed(4)
challenge = "61AB85A9746B81B5"
challenge = bytes.fromhex(challenge)                         
for i in range(0,4):
    challenge = random.getrandbits(8 * 8).to_bytes(8, 'little')
    (n_osc, valid_res) = run_puf(port, challenge, 10000)
    print("Valid results: " + str(valid_res))
    plt.plot(range(0,n_bistables*max_osc), n_osc/2)


plt.show()

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
