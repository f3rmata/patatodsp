// basic comb filter implemented in verilog.

module comb_filter 
  (
   input wire		  clk, // 时钟信号
   input wire		  rst_n,
   input wire		  cf_en, // 模块使能信号
   input wire [31:0]  audio_in,
   output wire [31:0] audio_out
   );

   parameter		  DELAY = 5;
   parameter		  STRENGTH = 1;
   parameter		  MIX = 0.5;

   	FP_Mult_Top wet_mix_mult 
	  (
	   .clk(clk), //input clk
	   .rstn(rstn), //input rstn
	   .data_a(data_a), //input [31:0] data_a
	   .data_b(data_b), //input [31:0] data_b
	   .overflow(overflow), //output overflow
	   .underflow(underflow), //output underflow
	   .nan(nan), //output nan
	   .zero(zero), //output zero
	   .result(result) //output [31:0] result
	   );
   
   Gowin_MULT wet_mix_mult 
	 (
      .dout(dout), //output [41:0] dout
      .a(a), //input [8:0] a
      .b(b), //input [32:0] b
      .clk(clk), //input clk
      .ce(ce), //input ce
      .reset(reset) //input reset
      );

   Gowin_MULT dry_mix_mult
	 (
	  .dout(dout), //output [41:0] dout
      .a(a), //input [8:0] a
      .b(b), //input [32:0] b
      .clk(clk), //input clk
      .ce(ce), //input ce
      .reset(reset) //input reset
      );

    Gowin_SDPB circular_buffer
	  (
        .dout(dout), //output [31:0] dout
        .clka(clka), //input clka
        .cea(cea), //input cea
        .clkb(clkb), //input clkb
        .ceb(ceb), //input ceb
        .oce(oce), //input oce
        .reset(reset), //input reset
        .ada(ada), //input [11:0] ada
        .din(din), //input [31:0] din
        .adb(adb) //input [11:0] adb
    );

endmodule // comb_filter
