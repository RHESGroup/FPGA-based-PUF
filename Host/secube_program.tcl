adapter driver hla
hla_layout stlink
hla_device_desc "ST-LINK/V2"
hla_vid_pid 0x0483 0x3748
transport select hla_swd

source [find target/stm32f4x.cfg]

# `st-info --probe` for the serial number

# Variable $serial must be set before sourcing this file
adapter serial $serial
gdb_port disabled

reset_config srst_only
puts "init openocd"
init

program "BOOT.elf" verify
puts "reset openocd"
reset

#Write the serial number into register R0 which is read by the st_serial procedure

wait_halt
reg r0 "0x[string range $serial_read 0 7]"
resume

wait_halt
reg r0 "0x[string range $serial_read 8 15]"
resume

wait_halt
reg r0 "0x[string range $serial_read 16 23]"
resume

exit