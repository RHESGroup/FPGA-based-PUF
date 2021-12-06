set impl_name [lindex $argv 0]
set n_inverters [lindex $argv 1]
set proj_path [pwd]

eco_design open -ncd "${proj_path}/${impl_name}/PUF_${impl_name}_map.ncd" -prf "${proj_path}/${impl_name}/PUF_${impl_name}.prf"


set start_row 2
set start_colum 16

proc place_puf_bistable {bist_id n_inverters start_row start_colum slice start_colum_counter inv_input enable_input challenge_input_1 challenge_input_2} {
	set slices {A B C D}

	set inverters_conf_string "MODE:LOGIC K1::H1=(~${inv_input}*~${enable_input}*${challenge_input_1}*${challenge_input_2})+(~${inv_input}*~${enable_input}*~${challenge_input_1}*${challenge_input_2})+(~${inv_input}*~${enable_input}*${challenge_input_1}*~${challenge_input_2})+(~${inv_input}*~${enable_input}*~${challenge_input_1}*~${challenge_input_2}) K0::H0=(~${inv_input}*~${enable_input}*${challenge_input_1}*${challenge_input_2})+(~${inv_input}*~${enable_input}*~${challenge_input_1}*${challenge_input_2})+(~${inv_input}*~${enable_input}*${challenge_input_1}*~${challenge_input_2})+(~${inv_input}*~${enable_input}*~${challenge_input_1}*~${challenge_input_2}) REG1:::REGSET=RESET,CLKDELAY=DEL0:SD=1 REG0:::REGSET=RESET,CLKDELAY=DEL0:SD=1 Q1:Q Q0:Q F1:F F0:F GSR:ENABLED CLKMUX:CLK:::0=0,CLK=#SIG CEMUX:1:::1=1,CE=#SIG LSRMUX:LSR:::0=0,LSR=#SIG OFX1:#OFF SRMODE:ASYNC OFX0:#OFF LSRONMUX:#OFF M1MUX:#OFF M0MUX:#OFF REGMODE:FF ALU2_MULT:#OFF FCO:#OFF CCU2:#OFF WDO0:#OFF WDO1:#OFF WADO0:#OFF WADO1:#OFF WADO2:#OFF WADO3:#OFF WDO2:#OFF WDO3:#OFF WD0MUX:#OFF WD1MUX:#OFF WD2MUX:#OFF WD3MUX:#OFF WAD0MUX:#OFF WAD1MUX:#OFF WAD2MUX:#OFF WAD3MUX:#OFF DPRAM:#OFF WCKMUX:#OFF WREMUX:#OFF"
	set counter_conf_string "MODE:LOGIC K1::H1=~A K0::H0=~A REG1:::REGSET=RESET,CLKDELAY=DEL0:SD=1 REG0:::REGSET=RESET,CLKDELAY=DEL0:SD=1 Q1:Q Q0:Q F1:#OFF F0:#OFF GSR:DISABLED CLKMUX:CLK:::0=0,CLK=#SIG CEMUX:1:::1=1,CE=#SIG LSRMUX:LSR:::0=0,LSR=#SIG OFX1:#OFF SRMODE:ASYNC OFX0:#OFF LSRONMUX:LSRMUX M1MUX:#OFF M0MUX:#OFF REGMODE:FF ALU2_MULT:#OFF FCO:#OFF CCU2:#OFF WDO0:#OFF WDO1:#OFF WADO0:#OFF WADO1:#OFF WADO2:#OFF WADO3:#OFF WDO2:#OFF WDO3:#OFF WD0MUX:#OFF WD1MUX:#OFF WD2MUX:#OFF WD3MUX:#OFF WAD0MUX:#OFF WAD1MUX:#OFF WAD2MUX:#OFF WAD3MUX:#OFF DPRAM:#OFF WCKMUX:#OFF WREMUX:#OFF"


	# Add components #

	set inv_comps [list]

	puts "bist${bist_id}: inserting inverters"

	#Inverters
	set row $start_row
	set colum $start_colum
	set i 0
	while {$i < $n_inverters/2+1} {
		set sliceLetter [lindex $slices $slice]
		set compName "bist${bist_id}_INV${i}"
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

	puts "bist${bist_id}: inserting counter ffs"

	set row [expr $start_row]
	set colum $start_colum_counter
	set slice 3
	set i 0
	while {$i < 16} {
		set sliceLetter [lindex $slices $slice]
		set compName "bist${bist_id}_COUNTER_FF${i}"
		set siteName "R${row}C${colum}${sliceLetter}"
		lappend counter_comps $siteName
		eco_add comp -name $compName -site $siteName
		eco_config comp -comp $compName $counter_conf_string
		
		if {$slice == 1} {
			set slice 3
			incr colum
		} else {
			set slice 1
		}
			
		incr i
	}

	return [list $inv_comps $counter_comps]
}

proc route_puf_bistable {bist_id inv_comps counter_comps n_inverters start_row start_colum slice start_colum_counter inv_input enable_input challenge_input_1 challenge_input_2} {
	set i 0
	while {$i < $n_inverters} {
		
	if {$i < [expr $n_inverters/2 -1]} {
			set siteName [lindex $inv_comps $i]
			set next_site_name [lindex $inv_comps [expr ($i+1)]]
			eco_add net -name "bist${bist_id}_inv_connections_${i}" -netpin "${siteName}.F1" -netpin "${next_site_name}.${inv_input}1"
		} elseif {$i == [expr $n_inverters/2 -1]} {
			set siteName [lindex $inv_comps $i]
			set next_site_name [lindex $inv_comps [expr ($i+1)]]
			eco_add net -name "bist${bist_id}_inv_connections_${i}" -netpin "${siteName}.F1" -netpin "${next_site_name}.${inv_input}0"
		} elseif {$i > [expr $n_inverters/2 -1] && $i < [expr $n_inverters -1]} {
			set siteName [lindex $inv_comps [expr $n_inverters -$i]]
			set next_site_name [lindex $inv_comps [expr $n_inverters - 1 -$i]]
			eco_add net -name "bist${bist_id}_inv_connections_${i}" -netpin "${siteName}.F0" -netpin "${next_site_name}.${inv_input}0"
		} else {
			set siteName [lindex $inv_comps [expr $n_inverters -$i]]
			set next_site_name [lindex $inv_comps 0]
			eco_add net -name "bist${bist_id}_inv_connections_${i}" -netpin "${siteName}.F0" -netpin "${next_site_name}.${inv_input}1"
		}
		#eco_add net -name "ff_connection_feedback${i}" -netpin "${siteName}.F0" -netpin "${siteName}.DI0"
		
		eco_route unroute -all
		incr i;
	}

	eco_route unroute -all


	set i 0
	while {$i < $n_inverters} {
		
		if {$i < [expr $n_inverters/2]} {
			set siteName [lindex $inv_comps $i]
			
			eco_add netpin -net "challenge_to_metastable_c_[expr 2*$i]" -netpin "$siteName.${challenge_input_1}1"
			eco_add netpin -net "challenge_to_metastable_c_[expr 2*$i+1]" -netpin "$siteName.${challenge_input_2}1"
			eco_add netpin -net "PUF1/enable_to_metastable_c" -netpin "$siteName.${enable_input}1"
		} else {
			set siteName [lindex $inv_comps [expr $n_inverters -$i]]
			
			eco_add netpin -net "challenge_to_metastable_c_[expr 2*$i]" -netpin "$siteName.${challenge_input_1}0"
			eco_add netpin -net "challenge_to_metastable_c_[expr 2*$i+1]" -netpin "$siteName.${challenge_input_2}0"
			eco_add netpin -net "PUF1/enable_to_metastable_c" -netpin "$siteName.${enable_input}0"
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
		set inv_conn_counted [expr $start_colum_counter - $start_colum]
		if {$i == 0} {
		
			eco_add netpin -net "bist${bist_id}_inv_connections_${inv_conn_counted}" -netpin "$siteName.CLK"

		} else {
			eco_add netpin -net "bist${bist_id}_feedback_ff_counter_c_[expr $i-1]" -netpin "$siteName.CLK"
		}	
		eco_add netpin -net "response_from_counter_c_[expr $bist_id*16 + $i]" -netpin "$siteName.Q0"
		eco_add netpin -net "response_from_counter_c_[expr $bist_id*16 + $i]" -netpin "$siteName.A0"

		eco_add net -name "bist${bist_id}_feedback_ff_counter_c_[expr $i]" -netpin "$siteName.F0" -netpin "$siteName.DI0"
		
		eco_route unroute -all
		incr i
	}

	eco_route unroute -all


	for {set i 0} {$i < $n_inverters} {incr i} {
		eco_route auto -net "bist${bist_id}_inv_connections_${i}"
	}


}


for {set i 0} {$i < [expr 2*$n_inverters]} {incr i} {
	eco_delete comp "challenge_to_metastable\[${i}\]"
}

for {set i 0} {$i < [expr 2*16]} {incr i} {
	eco_delete comp "response_from_counter\[${i}\]"
}

eco_delete comp "enable_to_metastable"

set comps0 [place_puf_bistable 0 $n_inverters $start_row $start_colum 0 $start_colum C D A B]
set comps1 [place_puf_bistable 1 $n_inverters $start_row $start_colum 2 [expr $start_colum + $n_inverters/4] B D A C]
eco_place auto -all

route_puf_bistable 0 [lindex $comps0 0] [lindex $comps0 1] $n_inverters $start_row $start_colum 0 $start_colum C D A B
route_puf_bistable 1 [lindex $comps1 0] [lindex $comps1 1] $n_inverters $start_row $start_colum 2 [expr $start_colum + $n_inverters/4] B D A C

# for {set i 0} {$i < [expr 2*$n_inverters]} {incr i} {
	# eco_route auto -net "challenge_to_metastable_c_${i}"
# }

#eco_route auto -net "PUF1/enable_to_metastable_c"


eco_route auto -all

eco_design save -ncd "${proj_path}/${impl_name}/PUF_${impl_name}.ncd"
eco_design close