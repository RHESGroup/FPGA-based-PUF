// Verilog netlist produced by program LSE :  version Diamond (64-bit) 3.12.0.240.2
// Netlist written on Fri Apr 30 18:01:48 2021
//
// Verilog Description of module dummy_lut
//

module dummy_lut (a, s, o);   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/dummy_lut.vhd(5[8:17])
    input a;   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/dummy_lut.vhd(6[13:14])
    input [2:0]s;   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/dummy_lut.vhd(7[13:14])
    output o;   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/dummy_lut.vhd(8[13:14])
    
    
    wire a_c, s_c_2, s_c_1, s_c_0, o_c, VCC_net, GND_net;
    
    PUR PUR_INST (.PUR(VCC_net));
    defparam PUR_INST.RST_PULSE = 1;
    TSALL TSALL_INST (.TSALL(GND_net));
    VHI i23 (.Z(VCC_net));
    VLO i28 (.Z(GND_net));
    OB o_pad (.I(o_c), .O(o));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/dummy_lut.vhd(8[13:14])
    IB a_pad (.I(a), .O(a_c));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/dummy_lut.vhd(6[13:14])
    IB s_pad_2 (.I(s[2]), .O(s_c_2));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/dummy_lut.vhd(7[13:14])
    IB s_pad_1 (.I(s[1]), .O(s_c_1));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/dummy_lut.vhd(7[13:14])
    IB s_pad_0 (.I(s[0]), .O(s_c_0));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/dummy_lut.vhd(7[13:14])
    GSR GSR_INST (.GSR(VCC_net));
    LUT4 i3_4_lut (.A(a_c), .B(s_c_2), .C(s_c_1), .D(s_c_0), .Z(o_c)) /* synthesis lut_function=(A (B (C (D)))) */ ;   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/dummy_lut.vhd(15[12:42])
    defparam i3_4_lut.init = 16'h8000;
    
endmodule
//
// Verilog Description of module PUR
// module not written out since it is a black-box. 
//

//
// Verilog Description of module TSALL
// module not written out since it is a black-box. 
//

