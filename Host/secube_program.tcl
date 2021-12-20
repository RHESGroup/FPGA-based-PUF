interface hla
hla_layout stlink
hla_device_desc "ST-LINK/V2"
hla_vid_pid 0x0483 0x3748
transport select hla_swd

source [find target/stm32f4x.cfg]

# `st-info --probe` for the serial number

# Variable $serial must be set before sourcing this file
hla_serial $serial
gdb_port disabled

reset_config srst_only
init

program "BOOT.elf" verify

reset
exit