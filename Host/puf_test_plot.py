import serial
import numpy

import sys
import mysql.connector
import random
import threading, queue
import matplotlib.pyplot as plt

max_osc = 1000

def run_puf(port, challenge, n=1000):
    global max_osc
    ser = serial.Serial(port)  # open serial port
    ser.rtscts = True
    ser.baudrate = 921600
    final_result_count = numpy.zeros(2, dtype=int)   
    n_osc = numpy.zeros(max_osc, dtype=int)
    valid_res=0
    ser.timeout = 0.1
    for i in range(0, n):
        ser.write(b'puff' + challenge + bytearray(4))
        puf_resp = ser.read(16)
        final_value = int.from_bytes(puf_resp[0:4], 'little')
        result = int.from_bytes(puf_resp[4:6], 'little')
        if ((final_value == 0xAAAAAAAA or final_value == 0x55555555) and result < max_osc):
            final_result_count[final_value&0x1] += 1
            valid_res+=1;    
            n_osc[result] += 1
    ser.close()
    
    
    
    return n_osc, valid_res, final_result_count
    


port = sys.argv[1]

#for i in range(0,10):
random.seed(0)                              
for i in range(0,4):
    challenge = random.getrandbits(8 * 8).to_bytes(8, 'little')
    (n_osc, valid_res, final_value_count) = run_puf(port, challenge, 10000)
    #q.put((port, challenge, valid_res, n_osc))
    #n_osc = n_osc/valid_res
    print("Valid results1: " + str(valid_res))
    print("Final values A: " + str(final_value_count[0]) + "    5: " + str(final_value_count[1]))
    plt.plot(range(0,max_osc), n_osc)


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
