import serial
import numpy
import matplotlib.pyplot as plt


def run_puf(port, challenge, n=1000):
    block_size = 4
    cursor = ['-', '\\', '|', '/']
    ser = serial.Serial(port)  # open serial port
    ser.rtscts = True
    ser.baudrate = 115200    
    n_osc = numpy.zeros(10000)
    valid_res=0
    ser.timeout = 2.0
    for i in range(0, n):
        ser.write(b'puff' + bytearray(challenge) + bytearray(4))
        puf_resp = ser.read(16)
        final_value = int.from_bytes(puf_resp[0:4], 'little')
        result = int.from_bytes(puf_resp[4:6], 'little')
        if (final_value == 0xAAAAAAAA or final_value == 0x55555555):
            valid_res+=1;    
            n_osc[result//block_size] += 1
            if (result % block_size >= block_size//2):
                n_osc[(result+block_size//2)//block_size] += 1
        print("  ["+cursor[(i//10)%4] + "]", end='\r')
    ser.close()
    return n_osc, valid_res 

challenge = [0, 0xaa, 0, 0, 0, 1, 0, 0]
challenge2 = [0, 0xaa, 0xff, 0xff, 0xff, 1, 0, 0]
n_osc, valid_res = run_puf('/dev/ttyUSB2', challenge, 10000)
n_osc = n_osc/valid_res
n_osc2, valid_res2 = run_puf('/dev/ttyUSB2', challenge2, 10000)
n_osc2 = n_osc2/valid_res2
#valid_res = len(n_osc)
#sigma = numpy.std(n_osc)
#avg = numpy.average(n_osc)
#plt.hist(n_osc, numpy.linspace(max(0, avg - 3 *sigma),avg + 3 *sigma,50))
dist = numpy.linalg.norm(n_osc-n_osc2)
#print("Number of oscillations: " + str(avg))
#print("Valid results: " + str(valid_res))
print("Valid results1: " + str(valid_res))
print("Valid results2: " + str(valid_res2))
print("Distance: " + str(dist))
plt.plot(range(0,10000), n_osc)
plt.plot(range(0,10000), n_osc2)
plt.show()

# ser.write(b'puff' + bytearray(challenge) + bytearray(4))
# puf_resp = ser.read(16)
# final_value = puf_resp[0:4].hex()
# avg = int.from_bytes(puf_resp[4:6], 'little')

#print("Final value: " + final_value)
#print("Number of oscillation: " + str(avg))
#print(puf_resp.hex())