// Verilog netlist produced by program LSE :  version Diamond (64-bit) 3.12.0.240.2
// Netlist written on Mon May  3 15:45:49 2021
//
// Verilog Description of module PUF
//

module PUF (clk, rst, challenge, response, finished);   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/PUF.vhd(4[8:11])
    input clk;   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/PUF.vhd(5[13:16])
    input rst;   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/PUF.vhd(5[18:21])
    input [2:0]challenge;   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/PUF.vhd(6[4:13])
    output response;   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/PUF.vhd(7[13:21])
    output finished;   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/PUF.vhd(8[4:12])
    
    
    wire GND_net, VCC_net;
    
    VHI i12 (.Z(VCC_net));
    OB response_pad (.I(GND_net), .O(response));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/PUF.vhd(7[13:21])
    OB finished_pad (.I(GND_net), .O(finished));   // /home/damiano/Documenti/Esami/Tesi/PUF/FPGA/PUF.vhd(8[4:12])
    GSR GSR_INST (.GSR(VCC_net));
    TSALL TSALL_INST (.TSALL(GND_net));
    PUR PUR_INST (.PUR(VCC_net));
    defparam PUR_INST.RST_PULSE = 1;
    VLO i4 (.Z(GND_net));
    
endmodule
//
// Verilog Description of module TSALL
// module not written out since it is a black-box. 
//

//
// Verilog Description of module PUR
// module not written out since it is a black-box. 
//

