import serial

ser = serial.Serial('COM3')  # open serial port
ser.rtscts = True
ser.baudrate = 57600

ser.write(b'fpga000000000000')
line = ser.read(16)
resp = line[0:8].decode("utf-8")
print(resp)
if not (resp == "fpgaprog"):
    print("Error programming FPGA1")
    exit()

line = ser.read(16)
resp = line[0:8].decode("utf-8")
print(resp)

if not (resp == "fpgaredy"):
    print("Error programming FPGA")
    exit()

print("FPGA programmed")
