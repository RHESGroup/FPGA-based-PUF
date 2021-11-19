import serial
import numpy
import matplotlib.pyplot as plt
import sys
import mysql.connector


def run_puf(port, challenge, mysql_cnx, n=1000):
    cursor = ['-', '\\', '|', '/']
    ser = serial.Serial(port)  # open serial port
    ser.rtscts = True
    ser.baudrate = 115200    
    n_osc = numpy.zeros(10000, dtype=int)
    valid_res=0
    ser.timeout = 2.0
    for i in range(0, n):
        ser.write(b'puff' + bytearray(challenge) + bytearray(4))
        puf_resp = ser.read(16)
        final_value = int.from_bytes(puf_resp[0:4], 'little')
        result = int.from_bytes(puf_resp[4:6], 'little')
        if (final_value == 0xAAAAAAAA or final_value == 0x55555555):
            valid_res+=1;    
            n_osc[result] += 1
    ser.close()
    
    cursor = mysql_cnx.cursor()
    
    add_run = ("INSERT INTO PUF_runs "
               "(secube, challenge, valid_responses) "
               "VALUES (%s, %s, %s)")
               
    data_run = (port, bytearray(challenge), valid_res)
    cursor.execute(add_run, data_run)
    
    run_id = cursor.lastrowid
    
    for i in range(0, 10000):
        if (n_osc[i] > 0):
            add_results = ("INSERT INTO PUF_results "
               "(runID, response, n_occurrences) "
               "VALUES (%s, %s, %s)")
               
            data_results = (run_id, i, int(n_osc[i]))
            cursor.execute(add_results, data_results)
    
    #mysql_cnx.commit()
    cursor.close();
    
    return n_osc, valid_res 
    

cnx = mysql.connector.connect(user='user', password='cc5XunxY',
                              host='127.0.0.1',
                              database='PUF_CRPs')

challenge = [65, 65, 3, 0, 65, 65, 65, 65]
challenge2 = [0, 0xaa, 0xff, 0xff, 0xff, 1, 0, 0]
n_osc, valid_res = run_puf(sys.argv[1], challenge, cnx, 1000)
n_osc = n_osc/valid_res
n_osc2, valid_res2 = run_puf(sys.argv[1], challenge2, cnx, 1000)
n_osc2 = n_osc2/valid_res2

cnx.close()

dist = numpy.linalg.norm(n_osc-n_osc2)
print("Valid results1: " + str(valid_res))
print("Valid results2: " + str(valid_res2))
print("Distance: " + str(dist))
plt.plot(range(0,10000), n_osc)
plt.plot(range(0,10000), n_osc2)
plt.show()
