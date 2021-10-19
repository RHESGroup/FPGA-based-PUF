set impl_name [lindex $argv 0]
set n_inverters [lindex $argv 1]

eco_design open -ncd "D:/Damiano/Documenti/Esami/Tesi/PUF/FPGA/${impl_name}/PUF_${impl_name}_map.ncd" -prf "D:/Damiano/Documenti/Esami/Tesi/PUF/FPGA/${impl_name}/PUF_${impl_name}.prf"

set slices {A B C D}

set start_row 2
set start_colum 3

set row $start_row
set colum $start_colum
set slice 0
set inverters_conf_string "MODE:LOGIC K1::H1=(~A*~C*B*D)+(~A*~C*~B*D)+(~A*~C*B*~D)+(~A*~C*~B*~D) K0::H0=~A REG1:::REGSET=RESET,CLKDELAY=DEL0:SD=1 REG0:::REGSET=RESET,CLKDELAY=DEL0:SD=1 Q1:Q Q0:Q F1:F F0:F GSR:ENABLED CLKMUX:CLK:::0=0,CLK=#SIG CEMUX:1:::1=1,CE=#SIG LSRMUX:#OFF OFX1:#OFF SRMODE:ASYNC OFX0:#OFF LSRONMUX:0 M1MUX:#OFF M0MUX:#OFF REGMODE:FF ALU2_MULT:#OFF FCO:#OFF CCU2:#OFF WDO0:#OFF WDO1:#OFF WADO0:#OFF WADO1:#OFF WADO2:#OFF WADO3:#OFF WDO2:#OFF WDO3:#OFF WD0MUX:#OFF WD1MUX:#OFF WD2MUX:#OFF WD3MUX:#OFF WAD0MUX:#OFF WAD1MUX:#OFF WAD2MUX:#OFF WAD3MUX:#OFF DPRAM:#OFF WCKMUX:#OFF WREMUX:#OFF"
set buffer_conf_string "MODE:LOGIC K1::H1=A K0::H0=OFF REG1:::REGSET=RESET,CLKDELAY=DEL0:SD=1 REG0:::REGSET=RESET,CLKDELAY=DEL0:SD=1 Q1:Q Q0:Q F1:F F0:F GSR:ENABLED CLKMUX:CLK:::0=0,CLK=#SIG CEMUX:1:::1=1,CE=#SIG LSRMUX:#OFF OFX1:#OFF SRMODE:ASYNC OFX0:#OFF LSRONMUX:0 M1MUX:#OFF M0MUX:#OFF REGMODE:FF ALU2_MULT:#OFF FCO:#OFF CCU2:#OFF WDO0:#OFF WDO1:#OFF WADO0:#OFF WADO1:#OFF WADO2:#OFF WADO3:#OFF WDO2:#OFF WDO3:#OFF WD0MUX:#OFF WD1MUX:#OFF WD2MUX:#OFF WD3MUX:#OFF WAD0MUX:#OFF WAD1MUX:#OFF WAD2MUX:#OFF WAD3MUX:#OFF DPRAM:#OFF WCKMUX:#OFF WREMUX:#OFF"


for {set i 0} {$i < [expr 2*$n_inverters]} {incr i} {
    eco_delete comp "challenge_to_metastable\[${i}\]"
}
eco_delete comp "response_from_metastable"
eco_delete comp "enable_to_metastable"


#eco_add netpin -net <net_name> -netpin <pin_name>
set i 0
while {$i < $n_inverters} {
	set sliceLetter [lindex $slices $slice]
	set compName "INV${i}"
	set siteName "R${row}C${colum}${sliceLetter}"
	eco_add comp -name $compName -site $siteName
	eco_config comp -comp $compName $inverters_conf_string
	
	if {$slice == 3} {
		set slice 0;
		incr colum
	} else {
		incr slice
	}
	
	
	incr i
}

#eco_add comp -name RESPONSE_BUFFER -site "R3C2D"
#eco_config comp -comp RESPONSE_BUFFER $inverters_conf_string

#eco_add comp [-name <comp name>] -site <site name>

set row $start_row
set colum $start_colum
set slice 0
set i 0
while {$i < $n_inverters} {
	set sliceLetter [lindex $slices $slice]
	set compName "INV${i}"
	set siteName "R${row}C${colum}${sliceLetter}"
	
	if {$slice == 3} {
		set slice 0;
		incr colum
	} else {
		incr slice
	}
	
	if {$i < [expr $n_inverters-1]} {
		set sliceLetter [lindex $slices $slice]
		set next_site_name "R${row}C${colum}${sliceLetter}"
	} else {
		set next_site_name "R${start_row}C${start_colum}A"
	}
	
	eco_add net -name "inv_connections_${i}" -netpin "${siteName}.F1" -netpin "${next_site_name}.A1" -netpin "$siteName.CLK"
	eco_add net -name "ff_connection_feedback${i}" -netpin "${siteName}.F0" -netpin "${siteName}.DI0"
	
	if {$i > 0} {
		eco_add net -name "ff_connection_${i}" -netpin "${siteName}.Q0" -netpin "${siteName}.A0"
		
	} else {
		
	}
	incr i;
}


eco_place auto -all


eco_add netpin -net "response_from_metastable_c" -netpin "R${start_row}C${start_colum}A.Q0" 
eco_add netpin -net "response_from_metastable_c" -netpin "R${start_row}C${start_colum}A.A0"

#eco_add netpin -net "response_from_metastable_c" -netpin "R2C2A.Q0"
#eco_add netpin -net "inv_connections_0" -netpin "R3C2D.A1"

set row $start_row
set colum $start_colum
set slice 0
set i 0
while {$i < $n_inverters} {
	set sliceLetter [lindex $slices $slice]
	#set compName "INV${i}"
	set siteName "R${row}C${colum}${sliceLetter}"
	
	#eco_add netpin -net "inv_connections_${i}" -netpin "$siteName.DI1"
	eco_add netpin -net "challenge_to_metastable_c_[expr 2*$i]" -netpin "$siteName.B1"
	eco_add netpin -net "challenge_to_metastable_c_[expr 2*$i+1]" -netpin "$siteName.D1"
	eco_add netpin -net "enable_to_metastable_c" -netpin "$siteName.C1"

	
	if {$slice == 3} {
		set slice 0;
		incr colum
	} else {
		incr slice
	}
	
	incr i
}

eco_route unroute -all
eco_route auto -all

eco_design save -ncd "D:/Damiano/Documenti/Esami/Tesi/PUF/FPGA/${impl_name}/PUF_${impl_name}.ncd"
eco_design close