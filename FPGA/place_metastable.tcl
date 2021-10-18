set impl_name [lindex $argv 0]

eco_design open -ncd "D:/Damiano/Documenti/Esami/Tesi/PUF/FPGA/${impl_name}/PUF_${impl_name}_map.ncd" -prf "D:/Damiano/Documenti/Esami/Tesi/PUF/FPGA/${impl_name}/PUF_${impl_name}.prf"

eco_add netpin -net <net_name> -netpin <pin_name>
eco_add comp [-name <comp name>] -site <site name>

set inverters_conf_string "MODE:LOGIC K1::H1=(~A*~C*B*D)+(~A*~C*~B*D)+(~A*~C*B*~D)+(~A*~C*~B*~D) K0::H0=(~A*~C*B*D)+(~A*~C*~B*D)+(~A*~C*B*~D)+(~A*~C*~B*~D) REG1:#OFF REG0:#OFF Q1:#OFF Q0:#OFF F1:F F0:F GSR:#OFF CLKMUX:#OFF CEMUX:#OFF LSRMUX:#OFF OFX1:#OFF SRMODE:#OFF OFX0:#OFF LSRONMUX:#OFF M1MUX:#OFF M0MUX:#OFF REGMODE:#OFF ALU2_MULT:#OFF FCO:#OFF CCU2:#OFF WDO0:#OFF WDO1:#OFF WADO0:#OFF WADO1:#OFF WADO2:#OFF WADO3:#OFF WDO2:#OFF WDO3:#OFF WD0MUX:#OFF WD1MUX:#OFF WD2MUX:#OFF WD3MUX:#OFF WAD0MUX:#OFF WAD1MUX:#OFF WAD2MUX:#OFF WAD3MUX:#OFF DPRAM:#OFF WCKMUX:#OFF WREMUX:#OFF"