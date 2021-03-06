import serial
import sys

ser = serial.Serial(sys.argv[1])  # open serial port
ser.rtscts = True
ser.baudrate = 921600

ser.write(b'fpga')
line = ser.read(8)
resp = line[0:8].decode("utf-8")
print(resp)
if not (resp == "fpgaprog"):
    print("Error programming FPGA1")
    exit()

line = ser.read(8)
resp = line[0:8].decode("utf-8")
print(resp)

if not (resp == "fpgaredy"):
    print("Error programming FPGA")
    exit()

print("FPGA programmed")
