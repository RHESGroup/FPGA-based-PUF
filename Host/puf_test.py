import serial
import numpy
import matplotlib.pyplot as plt

cursor = ['-', '\\', '|', '/']
ser = serial.Serial('COM3')  # open serial port
ser.rtscts = True
ser.baudrate = 115200
ser.write(b'helo000000000000000')
line = ser.read(16)
print(line.decode("utf-8"))
challenge = [48, 48, 48, 48, 255, 1, 20, 3]
n_osc = []
valid_res=0
#ser.timeout = 2.0
for i in range(0, 1000):
    ser.write(b'puff' + bytearray(challenge) + bytearray(4))
    puf_resp = ser.read(16)
    final_value = int.from_bytes(puf_resp[6:8], 'little')
    if (final_value == 0xAAAA or final_value == 0x5555):
        valid_res = valid_res+1       
        n_osc.append(int.from_bytes(puf_resp[0:6], 'little'))
    print("  ["+cursor[(i//10)%4] + "]", end='\r')

plt.hist(n_osc, numpy.linspace(min(n_osc),1000,50))
print("Number of oscillations: " + str(numpy.average(n_osc)))
print("Valid results: " + str(valid_res))
plt.show()



#print("Final value: " + final_value)
#print("Number of oscillation: " + str(avg))
#print(puf_resp.hex())
ser.close() 
