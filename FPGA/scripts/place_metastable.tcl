set impl_name [lindex $argv 0]
set n_inverters [lindex $argv 1]

eco_design open -ncd "D:/Damiano/Documenti/Esami/Tesi/PUF/FPGA/${impl_name}/PUF_${impl_name}_map.ncd" -prf "D:/Damiano/Documenti/Esami/Tesi/PUF/FPGA/${impl_name}/PUF_${impl_name}.prf"

set slices {A B C D}

set start_row 2
set start_colum 16


set inverters_conf_string "MODE:LOGIC K1::H1=(~A*~D*C*B)+(~A*~D*~C*B)+(~A*~D*C*~B)+(~A*~D*~C*~B) K0::H0=(~A*~D*C*B)+(~A*~D*~C*B)+(~A*~D*C*~B)+(~A*~D*~C*~B) REG1:::REGSET=RESET,CLKDELAY=DEL0:SD=1 REG0:::REGSET=RESET,CLKDELAY=DEL0:SD=1 Q1:Q Q0:Q F1:F F0:F GSR:ENABLED CLKMUX:CLK:::0=0,CLK=#SIG CEMUX:1:::1=1,CE=#SIG LSRMUX:LSR:::0=0,LSR=#SIG OFX1:#OFF SRMODE:ASYNC OFX0:#OFF LSRONMUX:#OFF M1MUX:#OFF M0MUX:#OFF REGMODE:FF ALU2_MULT:#OFF FCO:#OFF CCU2:#OFF WDO0:#OFF WDO1:#OFF WADO0:#OFF WADO1:#OFF WADO2:#OFF WADO3:#OFF WDO2:#OFF WDO3:#OFF WD0MUX:#OFF WD1MUX:#OFF WD2MUX:#OFF WD3MUX:#OFF WAD0MUX:#OFF WAD1MUX:#OFF WAD2MUX:#OFF WAD3MUX:#OFF DPRAM:#OFF WCKMUX:#OFF WREMUX:#OFF"
set counter_conf_string "MODE:LOGIC K1::H1=~A K0::H0=~A REG1:::REGSET=RESET,CLKDELAY=DEL0:SD=1 REG0:::REGSET=RESET,CLKDELAY=DEL0:SD=1 Q1:Q Q0:Q F1:#OFF F0:#OFF GSR:DISABLED CLKMUX:CLK:::0=0,CLK=#SIG CEMUX:1:::1=1,CE=#SIG LSRMUX:LSR:::0=0,LSR=#SIG OFX1:#OFF SRMODE:ASYNC OFX0:#OFF LSRONMUX:LSRMUX M1MUX:#OFF M0MUX:#OFF REGMODE:FF ALU2_MULT:#OFF FCO:#OFF CCU2:#OFF WDO0:#OFF WDO1:#OFF WADO0:#OFF WADO1:#OFF WADO2:#OFF WADO3:#OFF WDO2:#OFF WDO3:#OFF WD0MUX:#OFF WD1MUX:#OFF WD2MUX:#OFF WD3MUX:#OFF WAD0MUX:#OFF WAD1MUX:#OFF WAD2MUX:#OFF WAD3MUX:#OFF DPRAM:#OFF WCKMUX:#OFF WREMUX:#OFF"

for {set i 0} {$i < [expr 2*$n_inverters]} {incr i} {
    eco_delete comp "challenge_to_metastable\[${i}\]"
}

for {set i 0} {$i < 16} {incr i} {
    eco_delete comp "response_from_counter\[${i}\]"
}

for {set i 0} {$i < $n_inverters} {incr i} {
    eco_delete comp "response_from_metastable\[${i}\]"
}

eco_delete comp "enable_to_metastable"

# Add components #

set inv_comps [list]

#Inverters
set row $start_row
set colum $start_colum
set slice 0
set i 0
while {$i < $n_inverters/2} {
	set sliceLetter [lindex $slices $slice]
	set compName "INV${i}"
	set siteName "R${row}C${colum}${sliceLetter}"
	lappend inv_comps $siteName
	eco_add comp -name $compName -site $siteName
	eco_config comp -comp $compName $inverters_conf_string
	
	#if {$slice == 0} {
	#	set slice 3;
		incr colum
	#} else {
	#	set slice [expr $slice -1]
	#}
	
	
	incr i
}

#Asyncronous counter
set counter_comps [list]

set row [expr $start_row+1]
set colum $start_colum
set slice 3
set i 0
while {$i < 16} {
	set sliceLetter [lindex $slices $slice]
	set compName "COUNTER_FF${i}"
	set siteName "R${row}C${colum}${sliceLetter}"
	lappend counter_comps $siteName
	eco_add comp -name $compName -site $siteName
	eco_config comp -comp $compName $counter_conf_string
	
	if {$slice == 0} {
		set slice 3;
		incr colum
	} else {
		set slice [expr $slice -1]
	}
		
	incr i
}


set i 0
while {$i < $n_inverters} {
	
	if {$i < [expr $n_inverters/2 -1]} {
		set siteName [lindex $inv_comps $i]
		set next_site_name [lindex $inv_comps [expr ($i+1)]]
		eco_add net -name "inv_connections_${i}" -netpin "${siteName}.F1" -netpin "${next_site_name}.A1" -netpin "${siteName}.DI1"
		eco_add netpin -net "cpu_fpga_clk_c" -netpin "${siteName}.CLK"
	} elseif {$i == [expr $n_inverters/2 -1]} {
		set siteName [lindex $inv_comps $i]
		set next_site_name $siteName
		eco_add net -name "inv_connections_${i}" -netpin "${siteName}.F1" -netpin "${next_site_name}.A0" -netpin "${siteName}.DI1"
		eco_add netpin -net "cpu_fpga_clk_c" -netpin "${siteName}.CLK"
	} elseif {$i > [expr $n_inverters/2 -1] && $i < [expr $n_inverters -1]} {
		set siteName [lindex $inv_comps [expr $n_inverters - 1 -$i]]
		set next_site_name [lindex $inv_comps [expr $n_inverters - 2 -$i]]
		eco_add net -name "inv_connections_${i}" -netpin "${siteName}.F0" -netpin "${next_site_name}.A0" -netpin "${siteName}.DI0"
	} else {
		set siteName [lindex $inv_comps [expr $n_inverters - 1 -$i]]
		set next_site_name [lindex $inv_comps 0]
		eco_add net -name "inv_connections_${i}" -netpin "${siteName}.F0" -netpin "${next_site_name}.A1" -netpin "${siteName}.DI0"
	}
	#eco_add net -name "ff_connection_feedback${i}" -netpin "${siteName}.F0" -netpin "${siteName}.DI0"
	
	eco_route unroute -all
	incr i;
}


eco_place auto -all


set i 0
while {$i < $n_inverters} {
	
	if {$i < [expr $n_inverters/2]} {
		set siteName [lindex $inv_comps $i]
		
		eco_add netpin -net "challenge_to_metastable_c_[expr 2*$i]" -netpin "$siteName.C1"
		eco_add netpin -net "challenge_to_metastable_c_[expr 2*$i+1]" -netpin "$siteName.B1"
		eco_add netpin -net "PUF1/enable_to_metastable_c" -netpin "$siteName.D1"
		eco_add netpin -net "response_from_metastable_c_${i}" -netpin "${siteName}.Q1"
	} else {
		set siteName [lindex $inv_comps [expr $n_inverters - 1 -$i]]
		
		eco_add netpin -net "challenge_to_metastable_c_[expr 2*$i]" -netpin "$siteName.C0"
		eco_add netpin -net "challenge_to_metastable_c_[expr 2*$i+1]" -netpin "$siteName.B0"
		eco_add netpin -net "PUF1/enable_to_metastable_c" -netpin "$siteName.D0"
		eco_add netpin -net "response_from_metastable_c_${i}" -netpin "${siteName}.Q0"
	}
	
	
	eco_route unroute -all
	incr i
}

# Connect counter FF
set i 0
while {$i < 16} {
	set siteName [lindex $counter_comps $i]
	
	#eco_add netpin -net "inv_connections_${i}" -netpin "$siteName.DI1"
	eco_add netpin -net "PUF1/enable_to_metastable_c" -netpin "$siteName.LSR"
	if {$i == 0} {
	
		eco_add netpin -net "inv_connections_[expr $n_inverters-1]" -netpin "$siteName.CLK"

	} else {
		eco_add netpin -net "feedback_ff_counter_c_[expr $i-1]" -netpin "$siteName.CLK"
	}	
	eco_add netpin -net "response_from_counter_c_[expr $i]" -netpin "$siteName.Q0"
	eco_add netpin -net "response_from_counter_c_[expr $i]" -netpin "$siteName.A0"

	eco_add net -name "feedback_ff_counter_c_[expr $i]" -netpin "$siteName.F0" -netpin "$siteName.DI0"
	
	eco_route unroute -all
	incr i
}

eco_route unroute -all
eco_route auto -all

eco_design save -ncd "D:/Damiano/Documenti/Esami/Tesi/PUF/FPGA/${impl_name}/PUF_${impl_name}.ncd"
eco_design close