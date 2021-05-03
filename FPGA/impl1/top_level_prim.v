// Verilog netlist produced by program LSE :  version Diamond (64-bit) 3.12.0.240.2
// Netlist written on Mon May  3 11:33:48 2021
//
// Verilog Description of module top_level
//

module top_level (cpu_fpga_bus_a, cpu_fpga_bus_d, cpu_fpga_bus_noe, cpu_fpga_bus_nwe, 
            cpu_fpga_bus_ne1, cpu_fpga_clk, cpu_fpga_int_n, cpu_fpga_rst, 
            fpga_io_gp);   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(5[8:17])
    input [5:0]cpu_fpga_bus_a;   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(7[4:18])
    input [15:0]cpu_fpga_bus_d;   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(8[4:18])
    input cpu_fpga_bus_noe;   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(9[4:20])
    input cpu_fpga_bus_nwe;   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(10[4:20])
    input cpu_fpga_bus_ne1;   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(11[4:20])
    input cpu_fpga_clk;   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(12[4:16])
    output cpu_fpga_int_n;   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(13[4:18])
    input cpu_fpga_rst;   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(14[4:16])
    output [7:0]fpga_io_gp;   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(15[4:14])
    
    wire cpu_fpga_clk_c /* synthesis is_clock=1, SET_AS_NETWORK=cpu_fpga_clk_c */ ;   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(12[4:16])
    
    wire cpu_fpga_bus_d_c_7, cpu_fpga_bus_d_c_6, cpu_fpga_bus_d_c_5, cpu_fpga_bus_d_c_4, 
        cpu_fpga_bus_d_c_3, cpu_fpga_bus_d_c_2, cpu_fpga_bus_d_c_1, cpu_fpga_bus_d_c_0, 
        cpu_fpga_bus_nwe_c, cpu_fpga_bus_ne1_c, cpu_fpga_rst_c, fpga_io_gp_c_7, 
        fpga_io_gp_c_6, fpga_io_gp_c_5, fpga_io_gp_c_4, fpga_io_gp_c_3, 
        fpga_io_gp_c_2, fpga_io_gp_c_1, fpga_io_gp_c_0;
    wire [1:0]STATE;   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(23[9:14])
    
    wire n14, n15, n16, n17, n18, n19, n20, n21;
    wire [1:0]STATE_1__N_9;
    
    wire GND_net, cpu_fpga_clk_c_enable_8, n179, VCC_net;
    
    LUT4 STATE_1__I_0_26_Mux_1_i3_4_lut (.A(cpu_fpga_bus_ne1_c), .B(cpu_fpga_bus_nwe_c), 
         .C(STATE[1]), .D(STATE[0]), .Z(STATE_1__N_9[1])) /* synthesis lut_function=(A (B (C (D))+!B (C))+!A (B (D)+!B (C+(D)))) */ ;   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(39[4] 64[13])
    defparam STATE_1__I_0_26_Mux_1_i3_4_lut.init = 16'hf530;
    TSALL TSALL_INST (.TSALL(GND_net));
    OB fpga_io_gp_pad_2 (.I(fpga_io_gp_c_2), .O(fpga_io_gp[2]));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(15[4:14])
    GSR GSR_INST (.GSR(n179));
    FD1P3AY STATE_i0 (.D(cpu_fpga_bus_nwe_c), .SP(STATE[1]), .CK(cpu_fpga_clk_c), 
            .Q(STATE[0]));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(31[3] 65[10])
    defparam STATE_i0.GSR = "ENABLED";
    OB fpga_io_gp_pad_6 (.I(fpga_io_gp_c_6), .O(fpga_io_gp[6]));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(15[4:14])
    LUT4 inv_10_i4_1_lut (.A(cpu_fpga_bus_d_c_3), .Z(n18)) /* synthesis lut_function=(!(A)) */ ;   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(55[25:51])
    defparam inv_10_i4_1_lut.init = 16'h5555;
    FD1P3AY fpga_io_gp_i2 (.D(n20), .SP(cpu_fpga_clk_c_enable_8), .CK(cpu_fpga_clk_c), 
            .Q(fpga_io_gp_c_1));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(31[3] 65[10])
    defparam fpga_io_gp_i2.GSR = "ENABLED";
    LUT4 inv_10_i5_1_lut (.A(cpu_fpga_bus_d_c_4), .Z(n17)) /* synthesis lut_function=(!(A)) */ ;   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(55[25:51])
    defparam inv_10_i5_1_lut.init = 16'h5555;
    OB fpga_io_gp_pad_7 (.I(fpga_io_gp_c_7), .O(fpga_io_gp[7]));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(15[4:14])
    OB fpga_io_gp_pad_3 (.I(fpga_io_gp_c_3), .O(fpga_io_gp[3]));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(15[4:14])
    LUT4 i91_1_lut (.A(cpu_fpga_rst_c), .Z(n179)) /* synthesis lut_function=(!(A)) */ ;   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(14[4:16])
    defparam i91_1_lut.init = 16'h5555;
    LUT4 inv_10_i6_1_lut (.A(cpu_fpga_bus_d_c_5), .Z(n16)) /* synthesis lut_function=(!(A)) */ ;   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(55[25:51])
    defparam inv_10_i6_1_lut.init = 16'h5555;
    LUT4 inv_10_i2_1_lut (.A(cpu_fpga_bus_d_c_1), .Z(n20)) /* synthesis lut_function=(!(A)) */ ;   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(55[25:51])
    defparam inv_10_i2_1_lut.init = 16'h5555;
    LUT4 inv_10_i7_1_lut (.A(cpu_fpga_bus_d_c_6), .Z(n15)) /* synthesis lut_function=(!(A)) */ ;   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(55[25:51])
    defparam inv_10_i7_1_lut.init = 16'h5555;
    LUT4 inv_10_i3_1_lut (.A(cpu_fpga_bus_d_c_2), .Z(n19)) /* synthesis lut_function=(!(A)) */ ;   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(55[25:51])
    defparam inv_10_i3_1_lut.init = 16'h5555;
    VLO i19 (.Z(GND_net));
    OB cpu_fpga_int_n_pad (.I(GND_net), .O(cpu_fpga_int_n));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(13[4:18])
    OB fpga_io_gp_pad_4 (.I(fpga_io_gp_c_4), .O(fpga_io_gp[4]));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(15[4:14])
    OB fpga_io_gp_pad_5 (.I(fpga_io_gp_c_5), .O(fpga_io_gp[5]));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(15[4:14])
    OB fpga_io_gp_pad_1 (.I(fpga_io_gp_c_1), .O(fpga_io_gp[1]));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(15[4:14])
    OB fpga_io_gp_pad_0 (.I(fpga_io_gp_c_0), .O(fpga_io_gp[0]));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(15[4:14])
    IB cpu_fpga_bus_d_pad_7 (.I(cpu_fpga_bus_d[7]), .O(cpu_fpga_bus_d_c_7));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(8[4:18])
    IB cpu_fpga_bus_d_pad_6 (.I(cpu_fpga_bus_d[6]), .O(cpu_fpga_bus_d_c_6));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(8[4:18])
    IB cpu_fpga_bus_d_pad_5 (.I(cpu_fpga_bus_d[5]), .O(cpu_fpga_bus_d_c_5));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(8[4:18])
    IB cpu_fpga_bus_d_pad_4 (.I(cpu_fpga_bus_d[4]), .O(cpu_fpga_bus_d_c_4));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(8[4:18])
    IB cpu_fpga_bus_d_pad_3 (.I(cpu_fpga_bus_d[3]), .O(cpu_fpga_bus_d_c_3));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(8[4:18])
    IB cpu_fpga_bus_d_pad_2 (.I(cpu_fpga_bus_d[2]), .O(cpu_fpga_bus_d_c_2));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(8[4:18])
    IB cpu_fpga_bus_d_pad_1 (.I(cpu_fpga_bus_d[1]), .O(cpu_fpga_bus_d_c_1));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(8[4:18])
    IB cpu_fpga_bus_d_pad_0 (.I(cpu_fpga_bus_d[0]), .O(cpu_fpga_bus_d_c_0));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(8[4:18])
    IB cpu_fpga_bus_nwe_pad (.I(cpu_fpga_bus_nwe), .O(cpu_fpga_bus_nwe_c));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(10[4:20])
    IB cpu_fpga_bus_ne1_pad (.I(cpu_fpga_bus_ne1), .O(cpu_fpga_bus_ne1_c));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(11[4:20])
    IB cpu_fpga_clk_pad (.I(cpu_fpga_clk), .O(cpu_fpga_clk_c));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(12[4:16])
    IB cpu_fpga_rst_pad (.I(cpu_fpga_rst), .O(cpu_fpga_rst_c));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(14[4:16])
    PUR PUR_INST (.PUR(VCC_net));
    defparam PUR_INST.RST_PULSE = 1;
    FD1P3AY fpga_io_gp_i3 (.D(n19), .SP(cpu_fpga_clk_c_enable_8), .CK(cpu_fpga_clk_c), 
            .Q(fpga_io_gp_c_2));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(31[3] 65[10])
    defparam fpga_io_gp_i3.GSR = "ENABLED";
    FD1P3AY fpga_io_gp_i4 (.D(n18), .SP(cpu_fpga_clk_c_enable_8), .CK(cpu_fpga_clk_c), 
            .Q(fpga_io_gp_c_3));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(31[3] 65[10])
    defparam fpga_io_gp_i4.GSR = "ENABLED";
    FD1P3AY fpga_io_gp_i5 (.D(n17), .SP(cpu_fpga_clk_c_enable_8), .CK(cpu_fpga_clk_c), 
            .Q(fpga_io_gp_c_4));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(31[3] 65[10])
    defparam fpga_io_gp_i5.GSR = "ENABLED";
    FD1P3AY fpga_io_gp_i6 (.D(n16), .SP(cpu_fpga_clk_c_enable_8), .CK(cpu_fpga_clk_c), 
            .Q(fpga_io_gp_c_5));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(31[3] 65[10])
    defparam fpga_io_gp_i6.GSR = "ENABLED";
    FD1P3AY fpga_io_gp_i7 (.D(n15), .SP(cpu_fpga_clk_c_enable_8), .CK(cpu_fpga_clk_c), 
            .Q(fpga_io_gp_c_6));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(31[3] 65[10])
    defparam fpga_io_gp_i7.GSR = "ENABLED";
    FD1P3AY fpga_io_gp_i8 (.D(n14), .SP(cpu_fpga_clk_c_enable_8), .CK(cpu_fpga_clk_c), 
            .Q(fpga_io_gp_c_7));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(31[3] 65[10])
    defparam fpga_io_gp_i8.GSR = "ENABLED";
    FD1S3AX STATE_i1 (.D(STATE_1__N_9[1]), .CK(cpu_fpga_clk_c), .Q(STATE[1]));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(31[3] 65[10])
    defparam STATE_i1.GSR = "ENABLED";
    LUT4 inv_10_i8_1_lut (.A(cpu_fpga_bus_d_c_7), .Z(n14)) /* synthesis lut_function=(!(A)) */ ;   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(55[25:51])
    defparam inv_10_i8_1_lut.init = 16'h5555;
    LUT4 inv_10_i1_1_lut (.A(cpu_fpga_bus_d_c_0), .Z(n21)) /* synthesis lut_function=(!(A)) */ ;   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(55[25:51])
    defparam inv_10_i1_1_lut.init = 16'h5555;
    FD1P3AY fpga_io_gp_i1 (.D(n21), .SP(cpu_fpga_clk_c_enable_8), .CK(cpu_fpga_clk_c), 
            .Q(fpga_io_gp_c_0));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(31[3] 65[10])
    defparam fpga_io_gp_i1.GSR = "ENABLED";
    LUT4 i2_3_lut (.A(STATE[1]), .B(STATE[0]), .C(cpu_fpga_bus_nwe_c), 
         .Z(cpu_fpga_clk_c_enable_8)) /* synthesis lut_function=(!((B+!(C))+!A)) */ ;   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(39[4] 64[13])
    defparam i2_3_lut.init = 16'h2020;
    VHI i109 (.Z(VCC_net));
    
endmodule
//
// Verilog Description of module TSALL
// module not written out since it is a black-box. 
//

//
// Verilog Description of module PUR
// module not written out since it is a black-box. 
//

