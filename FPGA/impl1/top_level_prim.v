// Verilog netlist produced by program LSE :  version Diamond (64-bit) 3.12.0.240.2
// Netlist written on Mon May  3 15:30:00 2021
//
// Verilog Description of module top_level
//

module top_level (cpu_fpga_bus_a, cpu_fpga_bus_d, cpu_fpga_bus_noe, cpu_fpga_bus_nwe, 
            cpu_fpga_bus_ne1, cpu_fpga_clk, cpu_fpga_int_n, cpu_fpga_rst);   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(5[8:17])
    input [5:0]cpu_fpga_bus_a;   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(7[4:18])
    inout [15:0]cpu_fpga_bus_d;   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(8[4:18])
    input cpu_fpga_bus_noe;   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(9[4:20])
    input cpu_fpga_bus_nwe;   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(10[4:20])
    input cpu_fpga_bus_ne1;   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(11[4:20])
    input cpu_fpga_clk;   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(12[4:16])
    output cpu_fpga_int_n;   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(13[4:18])
    input cpu_fpga_rst;   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(14[4:16])
    
    wire cpu_fpga_clk_c /* synthesis is_clock=1, SET_AS_NETWORK=cpu_fpga_clk_c */ ;   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(12[4:16])
    
    wire VCC_net, cpu_fpga_bus_a_c_3, cpu_fpga_bus_a_c_2, cpu_fpga_bus_a_c_1, 
        cpu_fpga_bus_a_c_0, cpu_fpga_bus_nwe_c, cpu_fpga_bus_ne1_c, cpu_fpga_rst_c;
    wire [2:0]STATE;   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(22[9:14])
    wire [3:0]address;   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(26[9:16])
    
    wire n934, n385, n380, n744, n375, n47, STATE_2__N_25_c_0, 
        n933;
    wire [2:0]STATE_2__N_18;
    
    wire n932;
    wire [15:0]cpu_fpga_bus_d_15__N_1;
    
    wire GND_net, cpu_fpga_bus_d_15__N_17, n390, n395, n400, n405, 
        n410, n415, n420, n425, n430, n931, n435, n853, n440, 
        n445, n450, n930, n5, n462, n463, n464, n465, n466, 
        n467, n468, n469, n470, n471, n472, n473, n474, n475, 
        n476, n477, n479, n5_adj_1, n5_adj_2, n943, cpu_fpga_bus_d_out_9, 
        n942, cpu_fpga_bus_d_out_2, cpu_fpga_bus_d_out_7, cpu_fpga_bus_d_out_11, 
        cpu_fpga_bus_d_out_6, cpu_fpga_bus_d_out_14, cpu_fpga_bus_d_out_12, 
        cpu_fpga_bus_d_out_8, cpu_fpga_bus_d_out_4, cpu_fpga_bus_d_out_10, 
        n941, n539, cpu_fpga_bus_d_out_0, cpu_fpga_bus_d_out_15, cpu_fpga_bus_d_out_1, 
        cpu_fpga_bus_d_out_3, cpu_fpga_bus_d_out_5, n940, cpu_fpga_bus_d_out_13, 
        cpu_fpga_clk_c_enable_7, n966, cpu_fpga_clk_c_enable_16, n939, 
        cpu_fpga_clk_c_enable_20, cpu_fpga_clk_c_enable_19, cpu_fpga_clk_c_enable_17, 
        n731, n929, cpu_fpga_clk_c_enable_14, cpu_fpga_clk_c_enable_13, 
        n8, n938, n937, n936, cpu_fpga_clk_c_enable_12, n817, n922, 
        n915, cpu_fpga_clk_c_enable_10, n935, cpu_fpga_clk_c_enable_9, 
        cpu_fpga_clk_c_enable_8, cpu_fpga_clk_c_enable_21, cpu_fpga_clk_c_enable_3, 
        cpu_fpga_clk_c_enable_1, cpu_fpga_clk_c_enable_11, n990, cpu_fpga_clk_c_enable_5, 
        cpu_fpga_clk_c_enable_18, cpu_fpga_clk_c_enable_6, n967;
    
    VLO i46 (.Z(GND_net));
    LUT4 cpu_fpga_bus_nwe_c_bdd_3_lut (.A(STATE[0]), .B(STATE_2__N_25_c_0), 
         .C(STATE[1]), .Z(n966)) /* synthesis lut_function=(!(A+((C)+!B))) */ ;
    defparam cpu_fpga_bus_nwe_c_bdd_3_lut.init = 16'h0404;
    FD1P3AX creset_279 (.D(n990), .SP(cpu_fpga_clk_c_enable_1), .CK(cpu_fpga_clk_c), 
            .Q(n380));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(25[9:13])
    defparam creset_279.GSR = "ENABLED";
    LUT4 i793_3_lut (.A(n445), .B(n450), .C(address[0]), .Z(n936)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;
    defparam i793_3_lut.init = 16'hcaca;
    PFUMX i800 (.BLUT(n941), .ALUT(n942), .C0(address[3]), .Z(n943));
    FD1P3AX address_i1 (.D(cpu_fpga_bus_a_c_1), .SP(cpu_fpga_clk_c_enable_18), 
            .CK(cpu_fpga_clk_c), .Q(address[1]));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(35[3] 86[10])
    defparam address_i1.GSR = "ENABLED";
    FD1P3AX creset_275 (.D(n990), .SP(cpu_fpga_clk_c_enable_3), .CK(cpu_fpga_clk_c), 
            .Q(n375));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(25[9:13])
    defparam creset_275.GSR = "ENABLED";
    FD1S3IX cpu_fpga_bus_d_i5 (.D(n467), .CK(cpu_fpga_clk_c), .CD(n817), 
            .Q(cpu_fpga_bus_d_15__N_1[5]));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(35[3] 86[10])
    defparam cpu_fpga_bus_d_i5.GSR = "ENABLED";
    LUT4 i789_3_lut (.A(n405), .B(n410), .C(address[0]), .Z(n932)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;
    defparam i789_3_lut.init = 16'hcaca;
    LUT4 i788_3_lut (.A(n395), .B(n400), .C(address[0]), .Z(n931)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;
    defparam i788_3_lut.init = 16'hcaca;
    FD1P3AX address_i0 (.D(cpu_fpga_bus_a_c_0), .SP(cpu_fpga_clk_c_enable_18), 
            .CK(cpu_fpga_clk_c), .Q(address[0]));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(35[3] 86[10])
    defparam address_i0.GSR = "ENABLED";
    BB cpu_fpga_bus_d_pad_15 (.I(cpu_fpga_bus_d_15__N_1[15]), .T(n539), 
       .B(cpu_fpga_bus_d[15]), .O(cpu_fpga_bus_d_out_15));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(31[2] 87[14])
    FD1S3IX cpu_fpga_bus_d_i0 (.D(n462), .CK(cpu_fpga_clk_c), .CD(n817), 
            .Q(cpu_fpga_bus_d_15__N_1[0]));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(35[3] 86[10])
    defparam cpu_fpga_bus_d_i0.GSR = "ENABLED";
    LUT4 i709_4_lut (.A(STATE[0]), .B(STATE[2]), .C(n853), .D(STATE[1]), 
         .Z(STATE_2__N_18[1])) /* synthesis lut_function=(!(A (B+!(C+!(D)))+!A (B+!(C (D))))) */ ;   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(48[4] 85[13])
    defparam i709_4_lut.init = 16'h3022;
    FD1P3AX creset_283 (.D(n990), .SP(cpu_fpga_clk_c_enable_5), .CK(cpu_fpga_clk_c), 
            .Q(n385));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(25[9:13])
    defparam creset_283.GSR = "ENABLED";
    LUT4 cpu_fpga_bus_nwe_c_bdd_4_lut (.A(cpu_fpga_bus_nwe_c), .B(STATE[0]), 
         .C(STATE[1]), .D(cpu_fpga_bus_ne1_c), .Z(n967)) /* synthesis lut_function=(A (B (C+(D)))+!A (B (C+(D))+!B (C))) */ ;
    defparam cpu_fpga_bus_nwe_c_bdd_4_lut.init = 16'hdcd0;
    LUT4 i699_2_lut (.A(address[0]), .B(address[1]), .Z(n744)) /* synthesis lut_function=(A (B)) */ ;
    defparam i699_2_lut.init = 16'h8888;
    FD1S3AY STATE_i0 (.D(STATE_2__N_18[0]), .CK(cpu_fpga_clk_c), .Q(STATE[0]));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(35[3] 86[10])
    defparam STATE_i0.GSR = "ENABLED";
    FD1P3AX creset_287 (.D(n990), .SP(cpu_fpga_clk_c_enable_6), .CK(cpu_fpga_clk_c), 
            .Q(n390));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(25[9:13])
    defparam creset_287.GSR = "ENABLED";
    LUT4 i1_2_lut_3_lut_4_lut (.A(n47), .B(address[2]), .C(n5_adj_1), 
         .D(address[3]), .Z(cpu_fpga_clk_c_enable_12)) /* synthesis lut_function=(!((B+(C+!(D)))+!A)) */ ;
    defparam i1_2_lut_3_lut_4_lut.init = 16'h0200;
    LUT4 i1_2_lut_3_lut_4_lut_adj_1 (.A(n47), .B(address[2]), .C(n5_adj_2), 
         .D(address[3]), .Z(cpu_fpga_clk_c_enable_11)) /* synthesis lut_function=(!((B+(C+!(D)))+!A)) */ ;
    defparam i1_2_lut_3_lut_4_lut_adj_1.init = 16'h0200;
    FD1S3IX cpu_fpga_bus_d_i4 (.D(n466), .CK(cpu_fpga_clk_c), .CD(n817), 
            .Q(cpu_fpga_bus_d_15__N_1[4]));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(35[3] 86[10])
    defparam cpu_fpga_bus_d_i4.GSR = "ENABLED";
    LUT4 i787_3_lut (.A(n385), .B(n390), .C(address[0]), .Z(n930)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;
    defparam i787_3_lut.init = 16'hcaca;
    FD1P3AX creset_291 (.D(n990), .SP(cpu_fpga_clk_c_enable_7), .CK(cpu_fpga_clk_c), 
            .Q(n395));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(25[9:13])
    defparam creset_291.GSR = "ENABLED";
    FD1P3AX creset_295 (.D(n990), .SP(cpu_fpga_clk_c_enable_8), .CK(cpu_fpga_clk_c), 
            .Q(n400));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(25[9:13])
    defparam creset_295.GSR = "ENABLED";
    LUT4 i786_3_lut (.A(n375), .B(n380), .C(address[0]), .Z(n929)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;
    defparam i786_3_lut.init = 16'hcaca;
    LUT4 equal_270_i5_2_lut (.A(address[0]), .B(address[1]), .Z(n5_adj_2)) /* synthesis lut_function=(A+(B)) */ ;   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(25[9:13])
    defparam equal_270_i5_2_lut.init = 16'heeee;
    FD1S3IX cpu_fpga_bus_d_i3 (.D(n465), .CK(cpu_fpga_clk_c), .CD(n817), 
            .Q(cpu_fpga_bus_d_15__N_1[3]));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(35[3] 86[10])
    defparam cpu_fpga_bus_d_i3.GSR = "ENABLED";
    LUT4 i2_4_lut (.A(n922), .B(STATE_2__N_25_c_0), .C(STATE[0]), .D(cpu_fpga_bus_nwe_c), 
         .Z(cpu_fpga_clk_c_enable_18)) /* synthesis lut_function=(!((B (C+(D))+!B (C))+!A)) */ ;
    defparam i2_4_lut.init = 16'h020a;
    FD1P3AX creset_299 (.D(n990), .SP(cpu_fpga_clk_c_enable_9), .CK(cpu_fpga_clk_c), 
            .Q(n405));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(25[9:13])
    defparam creset_299.GSR = "ENABLED";
    FD1P3AX creset_303 (.D(n990), .SP(cpu_fpga_clk_c_enable_10), .CK(cpu_fpga_clk_c), 
            .Q(n410));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(25[9:13])
    defparam creset_303.GSR = "ENABLED";
    LUT4 i1_2_lut_3_lut_4_lut_adj_2 (.A(n47), .B(address[2]), .C(n5), 
         .D(address[3]), .Z(cpu_fpga_clk_c_enable_13)) /* synthesis lut_function=(!((B+(C+!(D)))+!A)) */ ;
    defparam i1_2_lut_3_lut_4_lut_adj_2.init = 16'h0200;
    FD1S3IX cpu_fpga_bus_d_i2 (.D(n464), .CK(cpu_fpga_clk_c), .CD(n817), 
            .Q(cpu_fpga_bus_d_15__N_1[2]));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(35[3] 86[10])
    defparam cpu_fpga_bus_d_i2.GSR = "ENABLED";
    LUT4 i790_3_lut (.A(n415), .B(n420), .C(address[0]), .Z(n933)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;
    defparam i790_3_lut.init = 16'hcaca;
    LUT4 i1_3_lut (.A(STATE[0]), .B(STATE_2__N_25_c_0), .C(n8), .Z(n915)) /* synthesis lut_function=(!(A+(B+!(C)))) */ ;   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(35[3] 86[10])
    defparam i1_3_lut.init = 16'h1010;
    FD1P3AX creset_307 (.D(n990), .SP(cpu_fpga_clk_c_enable_11), .CK(cpu_fpga_clk_c), 
            .Q(n415));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(25[9:13])
    defparam creset_307.GSR = "ENABLED";
    FD1P3AX creset_311 (.D(n990), .SP(cpu_fpga_clk_c_enable_12), .CK(cpu_fpga_clk_c), 
            .Q(n420));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(25[9:13])
    defparam creset_311.GSR = "ENABLED";
    LUT4 i1_2_lut_3_lut_4_lut_adj_3 (.A(n47), .B(address[2]), .C(n744), 
         .D(address[3]), .Z(cpu_fpga_clk_c_enable_14)) /* synthesis lut_function=(!((B+!(C (D)))+!A)) */ ;
    defparam i1_2_lut_3_lut_4_lut_adj_3.init = 16'h2000;
    IB cpu_fpga_rst_pad (.I(cpu_fpga_rst), .O(cpu_fpga_rst_c));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(14[4:16])
    FD1S3IX cpu_fpga_bus_d_i1 (.D(n463), .CK(cpu_fpga_clk_c), .CD(n817), 
            .Q(cpu_fpga_bus_d_15__N_1[1]));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(35[3] 86[10])
    defparam cpu_fpga_bus_d_i1.GSR = "ENABLED";
    FD1P3AX creset_315 (.D(n990), .SP(cpu_fpga_clk_c_enable_13), .CK(cpu_fpga_clk_c), 
            .Q(n425));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(25[9:13])
    defparam creset_315.GSR = "ENABLED";
    FD1P3AX creset_319 (.D(n990), .SP(cpu_fpga_clk_c_enable_14), .CK(cpu_fpga_clk_c), 
            .Q(n430));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(25[9:13])
    defparam creset_319.GSR = "ENABLED";
    LUT4 i1_2_lut_3_lut_4_lut_adj_4 (.A(n47), .B(address[2]), .C(n5_adj_1), 
         .D(address[3]), .Z(cpu_fpga_clk_c_enable_1)) /* synthesis lut_function=(!((B+(C+(D)))+!A)) */ ;
    defparam i1_2_lut_3_lut_4_lut_adj_4.init = 16'h0002;
    IB cpu_fpga_clk_pad (.I(cpu_fpga_clk), .O(cpu_fpga_clk_c));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(12[4:16])
    FD1P3AX address_i3 (.D(cpu_fpga_bus_a_c_3), .SP(cpu_fpga_clk_c_enable_18), 
            .CK(cpu_fpga_clk_c), .Q(address[3]));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(35[3] 86[10])
    defparam address_i3.GSR = "ENABLED";
    FD1P3AX creset_323 (.D(n990), .SP(cpu_fpga_clk_c_enable_16), .CK(cpu_fpga_clk_c), 
            .Q(n435));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(25[9:13])
    defparam creset_323.GSR = "ENABLED";
    FD1P3AX creset_327 (.D(n990), .SP(cpu_fpga_clk_c_enable_17), .CK(cpu_fpga_clk_c), 
            .Q(n440));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(25[9:13])
    defparam creset_327.GSR = "ENABLED";
    LUT4 i1_2_lut_3_lut_4_lut_adj_5 (.A(n47), .B(address[2]), .C(n5_adj_2), 
         .D(address[3]), .Z(cpu_fpga_clk_c_enable_3)) /* synthesis lut_function=(!((B+(C+(D)))+!A)) */ ;
    defparam i1_2_lut_3_lut_4_lut_adj_5.init = 16'h0002;
    FD1P3AX address_i2 (.D(cpu_fpga_bus_a_c_2), .SP(cpu_fpga_clk_c_enable_18), 
            .CK(cpu_fpga_clk_c), .Q(address[2]));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(35[3] 86[10])
    defparam address_i2.GSR = "ENABLED";
    LUT4 i1_2_lut_3_lut_4_lut_adj_6 (.A(n47), .B(address[2]), .C(n5), 
         .D(address[3]), .Z(cpu_fpga_clk_c_enable_5)) /* synthesis lut_function=(!((B+(C+(D)))+!A)) */ ;
    defparam i1_2_lut_3_lut_4_lut_adj_6.init = 16'h0002;
    FD1P3AX creset_331 (.D(n990), .SP(cpu_fpga_clk_c_enable_19), .CK(cpu_fpga_clk_c), 
            .Q(n445));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(25[9:13])
    defparam creset_331.GSR = "ENABLED";
    FD1P3AX creset (.D(n990), .SP(cpu_fpga_clk_c_enable_20), .CK(cpu_fpga_clk_c), 
            .Q(n450));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(25[9:13])
    defparam creset.GSR = "ENABLED";
    FD1S3IX cpu_fpga_bus_d_i15 (.D(n477), .CK(cpu_fpga_clk_c), .CD(n817), 
            .Q(cpu_fpga_bus_d_15__N_1[15]));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(35[3] 86[10])
    defparam cpu_fpga_bus_d_i15.GSR = "ENABLED";
    LUT4 i1_2_lut_3_lut_4_lut_adj_7 (.A(n47), .B(address[2]), .C(n744), 
         .D(address[3]), .Z(cpu_fpga_clk_c_enable_6)) /* synthesis lut_function=(!((B+((D)+!C))+!A)) */ ;
    defparam i1_2_lut_3_lut_4_lut_adj_7.init = 16'h0020;
    IB cpu_fpga_bus_ne1_pad (.I(cpu_fpga_bus_ne1), .O(cpu_fpga_bus_ne1_c));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(11[4:20])
    SPR16X4C BUFF1 (.DI0(cpu_fpga_bus_d_out_8), .DI1(cpu_fpga_bus_d_out_9), 
            .DI2(cpu_fpga_bus_d_out_10), .DI3(cpu_fpga_bus_d_out_11), .AD0(address[0]), 
            .AD1(address[1]), .AD2(address[2]), .AD3(address[3]), .CK(cpu_fpga_clk_c), 
            .WRE(n47), .DO0(n470), .DO1(n471), .DO2(n472), .DO3(n473));
    defparam BUFF1.initval = "0x0000000000000000";
    SPR16X4C BUFF2 (.DI0(cpu_fpga_bus_d_out_4), .DI1(cpu_fpga_bus_d_out_5), 
            .DI2(cpu_fpga_bus_d_out_6), .DI3(cpu_fpga_bus_d_out_7), .AD0(address[0]), 
            .AD1(address[1]), .AD2(address[2]), .AD3(address[3]), .CK(cpu_fpga_clk_c), 
            .WRE(n47), .DO0(n466), .DO1(n467), .DO2(n468), .DO3(n469));
    defparam BUFF2.initval = "0x0000000000000000";
    SPR16X4C BUFF3 (.DI0(cpu_fpga_bus_d_out_0), .DI1(cpu_fpga_bus_d_out_1), 
            .DI2(cpu_fpga_bus_d_out_2), .DI3(cpu_fpga_bus_d_out_3), .AD0(address[0]), 
            .AD1(address[1]), .AD2(address[2]), .AD3(address[3]), .CK(cpu_fpga_clk_c), 
            .WRE(n47), .DO0(n462), .DO1(n463), .DO2(n464), .DO3(n465));
    defparam BUFF3.initval = "0x0000000000000000";
    SPR16X4C BUFF0 (.DI0(cpu_fpga_bus_d_out_12), .DI1(cpu_fpga_bus_d_out_13), 
            .DI2(cpu_fpga_bus_d_out_14), .DI3(cpu_fpga_bus_d_out_15), .AD0(address[0]), 
            .AD1(address[1]), .AD2(address[2]), .AD3(address[3]), .CK(cpu_fpga_clk_c), 
            .WRE(n47), .DO0(n474), .DO1(n475), .DO2(n476), .DO3(n477));
    defparam BUFF0.initval = "0x0000000000000000";
    IB cpu_fpga_bus_nwe_pad (.I(cpu_fpga_bus_nwe), .O(cpu_fpga_bus_nwe_c));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(10[4:20])
    IB STATE_2__N_25_pad_0 (.I(cpu_fpga_bus_noe), .O(STATE_2__N_25_c_0));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(9[4:20])
    LUT4 i1_2_lut (.A(STATE[1]), .B(STATE[2]), .Z(n922)) /* synthesis lut_function=(!((B)+!A)) */ ;   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(48[4] 85[13])
    defparam i1_2_lut.init = 16'h2222;
    LUT4 i1_2_lut_3_lut_4_lut_adj_8 (.A(address[2]), .B(n47), .C(n5_adj_2), 
         .D(address[3]), .Z(cpu_fpga_clk_c_enable_16)) /* synthesis lut_function=(!(((C+!(D))+!B)+!A)) */ ;
    defparam i1_2_lut_3_lut_4_lut_adj_8.init = 16'h0800;
    IB cpu_fpga_bus_a_pad_0 (.I(cpu_fpga_bus_a[0]), .O(cpu_fpga_bus_a_c_0));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(7[4:18])
    LUT4 equal_273_i5_2_lut (.A(address[0]), .B(address[1]), .Z(n5_adj_1)) /* synthesis lut_function=((B)+!A) */ ;   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(25[9:13])
    defparam equal_273_i5_2_lut.init = 16'hdddd;
    IB cpu_fpga_bus_a_pad_1 (.I(cpu_fpga_bus_a[1]), .O(cpu_fpga_bus_a_c_1));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(7[4:18])
    IB cpu_fpga_bus_a_pad_2 (.I(cpu_fpga_bus_a[2]), .O(cpu_fpga_bus_a_c_2));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(7[4:18])
    IB cpu_fpga_bus_a_pad_3 (.I(cpu_fpga_bus_a[3]), .O(cpu_fpga_bus_a_c_3));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(7[4:18])
    OB cpu_fpga_int_n_pad (.I(GND_net), .O(cpu_fpga_int_n));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(13[4:18])
    BB cpu_fpga_bus_d_pad_0 (.I(cpu_fpga_bus_d_15__N_1[0]), .T(n539), .B(cpu_fpga_bus_d[0]), 
       .O(cpu_fpga_bus_d_out_0));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(31[2] 87[14])
    BB cpu_fpga_bus_d_pad_1 (.I(cpu_fpga_bus_d_15__N_1[1]), .T(n539), .B(cpu_fpga_bus_d[1]), 
       .O(cpu_fpga_bus_d_out_1));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(31[2] 87[14])
    LUT4 i1_2_lut_3_lut_4_lut_adj_9 (.A(address[2]), .B(n47), .C(n5_adj_1), 
         .D(address[3]), .Z(cpu_fpga_clk_c_enable_17)) /* synthesis lut_function=(!(((C+!(D))+!B)+!A)) */ ;
    defparam i1_2_lut_3_lut_4_lut_adj_9.init = 16'h0800;
    FD1S3IX cpu_fpga_bus_d_i14 (.D(n476), .CK(cpu_fpga_clk_c), .CD(n817), 
            .Q(cpu_fpga_bus_d_15__N_1[14]));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(35[3] 86[10])
    defparam cpu_fpga_bus_d_i14.GSR = "ENABLED";
    FD1S3IX cpu_fpga_bus_d_i13 (.D(n475), .CK(cpu_fpga_clk_c), .CD(n817), 
            .Q(cpu_fpga_bus_d_15__N_1[13]));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(35[3] 86[10])
    defparam cpu_fpga_bus_d_i13.GSR = "ENABLED";
    BB cpu_fpga_bus_d_pad_2 (.I(cpu_fpga_bus_d_15__N_1[2]), .T(n539), .B(cpu_fpga_bus_d[2]), 
       .O(cpu_fpga_bus_d_out_2));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(31[2] 87[14])
    FD1S3IX cpu_fpga_bus_d_i12 (.D(n474), .CK(cpu_fpga_clk_c), .CD(n817), 
            .Q(cpu_fpga_bus_d_15__N_1[12]));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(35[3] 86[10])
    defparam cpu_fpga_bus_d_i12.GSR = "ENABLED";
    FD1S3IX cpu_fpga_bus_d_i11 (.D(n473), .CK(cpu_fpga_clk_c), .CD(n817), 
            .Q(cpu_fpga_bus_d_15__N_1[11]));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(35[3] 86[10])
    defparam cpu_fpga_bus_d_i11.GSR = "ENABLED";
    BB cpu_fpga_bus_d_pad_3 (.I(cpu_fpga_bus_d_15__N_1[3]), .T(n539), .B(cpu_fpga_bus_d[3]), 
       .O(cpu_fpga_bus_d_out_3));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(31[2] 87[14])
    LUT4 i792_3_lut (.A(n435), .B(n440), .C(address[0]), .Z(n935)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;
    defparam i792_3_lut.init = 16'hcaca;
    FD1S3IX cpu_fpga_bus_d_i10 (.D(n472), .CK(cpu_fpga_clk_c), .CD(n817), 
            .Q(cpu_fpga_bus_d_15__N_1[10]));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(35[3] 86[10])
    defparam cpu_fpga_bus_d_i10.GSR = "ENABLED";
    BB cpu_fpga_bus_d_pad_4 (.I(cpu_fpga_bus_d_15__N_1[4]), .T(n539), .B(cpu_fpga_bus_d[4]), 
       .O(cpu_fpga_bus_d_out_4));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(31[2] 87[14])
    LUT4 i19_3_lut (.A(cpu_fpga_bus_nwe_c), .B(STATE[2]), .C(STATE[1]), 
         .Z(n8)) /* synthesis lut_function=(!(A (B (C)+!B !(C))+!A ((C)+!B))) */ ;   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(35[3] 86[10])
    defparam i19_3_lut.init = 16'h2c2c;
    BB cpu_fpga_bus_d_pad_5 (.I(cpu_fpga_bus_d_15__N_1[5]), .T(n539), .B(cpu_fpga_bus_d[5]), 
       .O(cpu_fpga_bus_d_out_5));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(31[2] 87[14])
    FD1S3IX cpu_fpga_bus_d_i9 (.D(n471), .CK(cpu_fpga_clk_c), .CD(n817), 
            .Q(cpu_fpga_bus_d_15__N_1[9]));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(35[3] 86[10])
    defparam cpu_fpga_bus_d_i9.GSR = "ENABLED";
    BB cpu_fpga_bus_d_pad_6 (.I(cpu_fpga_bus_d_15__N_1[6]), .T(n539), .B(cpu_fpga_bus_d[6]), 
       .O(cpu_fpga_bus_d_out_6));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(31[2] 87[14])
    BB cpu_fpga_bus_d_pad_7 (.I(cpu_fpga_bus_d_15__N_1[7]), .T(n539), .B(cpu_fpga_bus_d[7]), 
       .O(cpu_fpga_bus_d_out_7));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(31[2] 87[14])
    LUT4 i3_4_lut (.A(cpu_fpga_bus_nwe_c), .B(STATE[0]), .C(cpu_fpga_rst_c), 
         .D(n922), .Z(n47)) /* synthesis lut_function=(!(((C+!(D))+!B)+!A)) */ ;   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(48[4] 85[13])
    defparam i3_4_lut.init = 16'h0800;
    FD1S3IX cpu_fpga_bus_d_i8 (.D(n470), .CK(cpu_fpga_clk_c), .CD(n817), 
            .Q(cpu_fpga_bus_d_15__N_1[8]));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(35[3] 86[10])
    defparam cpu_fpga_bus_d_i8.GSR = "ENABLED";
    FD1S3IX cpu_fpga_bus_d_i7 (.D(n469), .CK(cpu_fpga_clk_c), .CD(n817), 
            .Q(cpu_fpga_bus_d_15__N_1[7]));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(35[3] 86[10])
    defparam cpu_fpga_bus_d_i7.GSR = "ENABLED";
    BB cpu_fpga_bus_d_pad_8 (.I(cpu_fpga_bus_d_15__N_1[8]), .T(n539), .B(cpu_fpga_bus_d[8]), 
       .O(cpu_fpga_bus_d_out_8));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(31[2] 87[14])
    BB cpu_fpga_bus_d_pad_9 (.I(cpu_fpga_bus_d_15__N_1[9]), .T(n539), .B(cpu_fpga_bus_d[9]), 
       .O(cpu_fpga_bus_d_out_9));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(31[2] 87[14])
    LUT4 i1_2_lut_3_lut_4_lut_adj_10 (.A(address[2]), .B(n47), .C(n5), 
         .D(address[3]), .Z(cpu_fpga_clk_c_enable_19)) /* synthesis lut_function=(!(((C+!(D))+!B)+!A)) */ ;
    defparam i1_2_lut_3_lut_4_lut_adj_10.init = 16'h0800;
    FD1P3AX STATE_i1 (.D(STATE_2__N_18[1]), .SP(cpu_fpga_clk_c_enable_21), 
            .CK(cpu_fpga_clk_c), .Q(STATE[1]));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(35[3] 86[10])
    defparam STATE_i1.GSR = "ENABLED";
    BB cpu_fpga_bus_d_pad_10 (.I(cpu_fpga_bus_d_15__N_1[10]), .T(n539), 
       .B(cpu_fpga_bus_d[10]), .O(cpu_fpga_bus_d_out_10));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(31[2] 87[14])
    BB cpu_fpga_bus_d_pad_11 (.I(cpu_fpga_bus_d_15__N_1[11]), .T(n539), 
       .B(cpu_fpga_bus_d[11]), .O(cpu_fpga_bus_d_out_11));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(31[2] 87[14])
    BB cpu_fpga_bus_d_pad_12 (.I(cpu_fpga_bus_d_15__N_1[12]), .T(n539), 
       .B(cpu_fpga_bus_d[12]), .O(cpu_fpga_bus_d_out_12));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(31[2] 87[14])
    PFUMX i815 (.BLUT(n967), .ALUT(n966), .C0(STATE[2]), .Z(STATE_2__N_18[0]));
    BB cpu_fpga_bus_d_pad_13 (.I(cpu_fpga_bus_d_15__N_1[13]), .T(n539), 
       .B(cpu_fpga_bus_d[13]), .O(cpu_fpga_bus_d_out_13));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(31[2] 87[14])
    BB cpu_fpga_bus_d_pad_14 (.I(cpu_fpga_bus_d_15__N_1[14]), .T(n539), 
       .B(cpu_fpga_bus_d[14]), .O(cpu_fpga_bus_d_out_14));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(31[2] 87[14])
    LUT4 i1_2_lut_3_lut_4_lut_adj_11 (.A(address[2]), .B(n47), .C(n744), 
         .D(address[3]), .Z(cpu_fpga_clk_c_enable_20)) /* synthesis lut_function=(A (B (C (D)))) */ ;
    defparam i1_2_lut_3_lut_4_lut_adj_11.init = 16'h8000;
    FD1S3IX i57_214 (.D(n731), .CK(cpu_fpga_clk_c), .CD(STATE_2__N_25_c_0), 
            .Q(cpu_fpga_bus_d_15__N_17));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(35[3] 86[10])
    defparam i57_214.GSR = "ENABLED";
    LUT4 i343_1_lut (.A(cpu_fpga_rst_c), .Z(n479)) /* synthesis lut_function=(!(A)) */ ;   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(14[4:16])
    defparam i343_1_lut.init = 16'h5555;
    LUT4 i1_2_lut_3_lut_4_lut_adj_12 (.A(address[2]), .B(n47), .C(n5_adj_2), 
         .D(address[3]), .Z(cpu_fpga_clk_c_enable_7)) /* synthesis lut_function=(!(((C+(D))+!B)+!A)) */ ;
    defparam i1_2_lut_3_lut_4_lut_adj_12.init = 16'h0008;
    LUT4 i798_3_lut (.A(n937), .B(n938), .C(address[2]), .Z(n941)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;
    defparam i798_3_lut.init = 16'hcaca;
    LUT4 i383_1_lut (.A(cpu_fpga_bus_d_15__N_17), .Z(n539)) /* synthesis lut_function=(!(A)) */ ;   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(31[2] 87[14])
    defparam i383_1_lut.init = 16'h5555;
    FD1S3AX STATE_i2 (.D(n915), .CK(cpu_fpga_clk_c), .Q(STATE[2]));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(35[3] 86[10])
    defparam STATE_i2.GSR = "ENABLED";
    LUT4 i1_2_lut_3_lut_4_lut_adj_13 (.A(address[2]), .B(n47), .C(n5_adj_1), 
         .D(address[3]), .Z(cpu_fpga_clk_c_enable_8)) /* synthesis lut_function=(!(((C+(D))+!B)+!A)) */ ;
    defparam i1_2_lut_3_lut_4_lut_adj_13.init = 16'h0008;
    PFUMX i794 (.BLUT(n929), .ALUT(n930), .C0(address[1]), .Z(n937));
    LUT4 i1_2_lut_3_lut_4_lut_adj_14 (.A(address[2]), .B(n47), .C(n5), 
         .D(address[3]), .Z(cpu_fpga_clk_c_enable_9)) /* synthesis lut_function=(!(((C+(D))+!B)+!A)) */ ;
    defparam i1_2_lut_3_lut_4_lut_adj_14.init = 16'h0008;
    PFUMX i797 (.BLUT(n935), .ALUT(n936), .C0(address[1]), .Z(n940));
    LUT4 i1_2_lut_3_lut_4_lut_adj_15 (.A(address[2]), .B(n47), .C(n744), 
         .D(address[3]), .Z(cpu_fpga_clk_c_enable_10)) /* synthesis lut_function=(!((((D)+!C)+!B)+!A)) */ ;
    defparam i1_2_lut_3_lut_4_lut_adj_15.init = 16'h0080;
    FD1S3IX cpu_fpga_bus_d_i6 (.D(n468), .CK(cpu_fpga_clk_c), .CD(n817), 
            .Q(cpu_fpga_bus_d_15__N_1[6]));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(35[3] 86[10])
    defparam cpu_fpga_bus_d_i6.GSR = "ENABLED";
    LUT4 i799_3_lut (.A(n939), .B(n940), .C(address[2]), .Z(n942)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;
    defparam i799_3_lut.init = 16'hcaca;
    LUT4 i3_4_lut_adj_16 (.A(cpu_fpga_bus_ne1_c), .B(STATE[2]), .C(STATE[1]), 
         .D(STATE[0]), .Z(cpu_fpga_clk_c_enable_21)) /* synthesis lut_function=((B+(C+!(D)))+!A) */ ;
    defparam i3_4_lut_adj_16.init = 16'hfdff;
    LUT4 i791_3_lut (.A(n425), .B(n430), .C(address[0]), .Z(n934)) /* synthesis lut_function=(A (B+!(C))+!A (B (C))) */ ;
    defparam i791_3_lut.init = 16'hcaca;
    PFUMX i795 (.BLUT(n931), .ALUT(n932), .C0(address[1]), .Z(n938));
    LUT4 i708_3_lut_3_lut (.A(cpu_fpga_bus_nwe_c), .B(STATE_2__N_25_c_0), 
         .C(STATE[0]), .Z(n853)) /* synthesis lut_function=(!(A ((C)+!B))) */ ;   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(56[6] 64[13])
    defparam i708_3_lut_3_lut.init = 16'h5d5d;
    LUT4 equal_277_i5_2_lut (.A(address[0]), .B(address[1]), .Z(n5)) /* synthesis lut_function=(A+!(B)) */ ;   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/impl1/source/top_level.vhd(25[9:13])
    defparam equal_277_i5_2_lut.init = 16'hbbbb;
    VHI i826 (.Z(VCC_net));
    LUT4 i811_2_lut_3_lut (.A(STATE[0]), .B(STATE[1]), .C(STATE[2]), .Z(n731)) /* synthesis lut_function=(!(A+(B+!(C)))) */ ;
    defparam i811_2_lut_3_lut.init = 16'h1010;
    LUT4 i814_3_lut_4_lut (.A(STATE[0]), .B(STATE[1]), .C(STATE[2]), .D(n943), 
         .Z(n817)) /* synthesis lut_function=(A+(B+!(C (D)))) */ ;
    defparam i814_3_lut_4_lut.init = 16'hefff;
    TSALL TSALL_INST (.TSALL(GND_net));
    PUR PUR_INST (.PUR(VCC_net));
    defparam PUR_INST.RST_PULSE = 1;
    LUT4 m1_lut (.Z(n990)) /* synthesis lut_function=1, syn_instantiated=1 */ ;
    defparam m1_lut.init = 16'hffff;
    GSR GSR_INST (.GSR(n479));
    PFUMX i796 (.BLUT(n933), .ALUT(n934), .C0(address[1]), .Z(n939));
    
endmodule
//
// Verilog Description of module TSALL
// module not written out since it is a black-box. 
//

//
// Verilog Description of module PUR
// module not written out since it is a black-box. 
//

