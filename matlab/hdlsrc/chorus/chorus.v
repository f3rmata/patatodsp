// -------------------------------------------------------------
// 
// File Name: hdlsrc/chorus/chorus.v
// Created: 2024-11-03 17:03:34
// 
// Generated by MATLAB 24.1, HDL Coder 24.1, and Simulink 24.1
// 
// 
// -- -------------------------------------------------------------
// -- Rate and Clocking Details
// -- -------------------------------------------------------------
// Model base rate: 0.4
// Target subsystem base rate: 0.4
// 
// 
// Clock Enable  Sample Time
// -- -------------------------------------------------------------
// ce_out        0.4
// -- -------------------------------------------------------------
// 
// 
// Output Signal                 Clock Enable  Sample Time
// -- -------------------------------------------------------------
// Out1                          ce_out        0.4
// -- -------------------------------------------------------------
// 
// -------------------------------------------------------------


// -------------------------------------------------------------
// 
// Module: chorus
// Source Path: chorus
// Hierarchy Level: 0
// Model version: 1.11
// 
// -------------------------------------------------------------

`timescale 1 ns / 1 ns

module chorus
          (clk,
           reset,
           clk_enable,
           In1,
           In2,
           ce_out,
           Out1);


  input   clk;
  input   reset;
  input   clk_enable;
  input   signed [31:0] In1;  // int32
  input   [15:0] In2;  // uint16
  output  ce_out;
  output  signed [31:0] Out1;  // int32


  wire enb;
  wire [15:0] ctrlSat;  // uint16
  reg signed [31:0] Delay1_reg [0:1023];  // sfix32 [1024]
  reg signed [31:0] Delay1_reg_next [0:1023];  // sfix32 [1024]
  reg signed [31:0] delayTapWire [0:1024];  // int32 [1025]
  wire signed [31:0] multiportswitch_idx;  // int32
  wire [16:0] multiportswitch_add_temp;  // ufix17
  wire [16:0] multiportswitch_1;  // ufix17
  wire signed [31:0] Delay1_out1;  // int32
  wire signed [63:0] Gain1_out1;  // sfix64_En31
  wire signed [63:0] Gain2_out1;  // sfix64_En30
  wire signed [31:0] Sum1_add_cast;  // sfix32
  wire signed [32:0] Sum1_add_cast_1;  // sfix33
  wire signed [31:0] Sum1_add_cast_2;  // sfix32
  wire signed [32:0] Sum1_add_cast_3;  // sfix33
  wire signed [32:0] Sum1_add_temp;  // sfix33
  wire signed [31:0] Sum1_out1;  // int32
  reg signed [31:0] Delay1_t_0_0;  // int32
  reg signed [31:0] Delay1_t_1;  // int32
  reg signed [31:0] Delay1_t_0_1;  // int32
  reg signed [31:0] Delay1_t_1_0;  // int32


  assign ctrlSat = (In2 > 16'b0000010000000000 ? 16'b0000010000000000 :
              In2);



  assign enb = clk_enable;

  always @(posedge clk or posedge reset)
    begin : Delay1_process
      if (reset == 1'b1) begin
        for(Delay1_t_1_0 = 32'sd0; Delay1_t_1_0 <= 32'sd1023; Delay1_t_1_0 = Delay1_t_1_0 + 32'sd1) begin
          Delay1_reg[Delay1_t_1_0] <= 32'sb00000000000000000000000000000000;
        end
      end
      else begin
        if (enb) begin
          for(Delay1_t_0_1 = 32'sd0; Delay1_t_0_1 <= 32'sd1023; Delay1_t_0_1 = Delay1_t_0_1 + 32'sd1) begin
            Delay1_reg[Delay1_t_0_1] <= Delay1_reg_next[Delay1_t_0_1];
          end
        end
      end
    end

  always @* begin
    delayTapWire[0] = In1;

    for(Delay1_t_0_0 = 32'sd0; Delay1_t_0_0 <= 32'sd1023; Delay1_t_0_0 = Delay1_t_0_0 + 32'sd1) begin
      delayTapWire[Delay1_t_0_0 + 32'sd1] = Delay1_reg[Delay1_t_0_0];
    end

    Delay1_reg_next[0] = In1;

    for(Delay1_t_1 = 32'sd0; Delay1_t_1 <= 32'sd1022; Delay1_t_1 = Delay1_t_1 + 32'sd1) begin
      Delay1_reg_next[Delay1_t_1 + 32'sd1] = Delay1_reg[Delay1_t_1];
    end

  end



  assign multiportswitch_1 = {1'b0, ctrlSat};
  assign multiportswitch_add_temp = multiportswitch_1 + 17'b00000000000000001;
  assign multiportswitch_idx = {15'b0, multiportswitch_add_temp};
  assign Delay1_out1 = (multiportswitch_idx <= 32'sd1025 ? delayTapWire[multiportswitch_idx - 32'sd1] :
              delayTapWire[1024]);



  assign Gain1_out1 = 32'sb01011010011111101111100111011011 * Delay1_out1;



  assign Gain2_out1 = {{2{In1[31]}}, {In1, 30'b000000000000000000000000000000}};



  assign Sum1_add_cast = (((Gain1_out1[63] == 1'b0) && (Gain1_out1[62] != 1'b0)) || ((Gain1_out1[63] == 1'b0) && (Gain1_out1[62:31] == 32'sb01111111111111111111111111111111)) ? 32'sb01111111111111111111111111111111 :
              ((Gain1_out1[63] == 1'b1) && (Gain1_out1[62] != 1'b1) ? 32'sb10000000000000000000000000000000 :
              Gain1_out1[62:31] + $signed({1'b0, Gain1_out1[30] & (( ~ Gain1_out1[63]) | (|Gain1_out1[29:0]))})));
  assign Sum1_add_cast_1 = {Sum1_add_cast[31], Sum1_add_cast};
  assign Sum1_add_cast_2 = (((Gain2_out1[63] == 1'b0) && (Gain2_out1[62:61] != 2'b00)) || ((Gain2_out1[63] == 1'b0) && (Gain2_out1[61:30] == 32'sb01111111111111111111111111111111)) ? 32'sb01111111111111111111111111111111 :
              ((Gain2_out1[63] == 1'b1) && (Gain2_out1[62:61] != 2'b11) ? 32'sb10000000000000000000000000000000 :
              Gain2_out1[61:30] + $signed({1'b0, Gain2_out1[29] & (( ~ Gain2_out1[63]) | (|Gain2_out1[28:0]))})));
  assign Sum1_add_cast_3 = {Sum1_add_cast_2[31], Sum1_add_cast_2};
  assign Sum1_add_temp = Sum1_add_cast_1 + Sum1_add_cast_3;
  assign Sum1_out1 = ((Sum1_add_temp[32] == 1'b0) && (Sum1_add_temp[31] != 1'b0) ? 32'sb01111111111111111111111111111111 :
              ((Sum1_add_temp[32] == 1'b1) && (Sum1_add_temp[31] != 1'b1) ? 32'sb10000000000000000000000000000000 :
              $signed(Sum1_add_temp[31:0])));



  assign Out1 = Sum1_out1;

  assign ce_out = clk_enable;

endmodule  // chorus

