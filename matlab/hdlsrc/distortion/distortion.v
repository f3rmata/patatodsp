// -------------------------------------------------------------
// 
// File Name: hdlsrc/distortion/distortion.v
// Created: 2024-10-31 00:07:20
// 
// Generated by MATLAB 24.1, HDL Coder 24.1, and Simulink 24.1
// 
// 
// -- -------------------------------------------------------------
// -- Rate and Clocking Details
// -- -------------------------------------------------------------
// Model base rate: 0
// Target subsystem base rate: 0
// 
// -------------------------------------------------------------


// -------------------------------------------------------------
// 
// Module: distortion
// Source Path: distortion
// Hierarchy Level: 0
// Model version: 1.2
// 
// -------------------------------------------------------------

`timescale 1 ns / 1 ns

module distortion
          (In1,
           Out1);


  input   signed [31:0] In1;  // int32
  output  signed [31:0] Out1;  // int32


  wire signed [63:0] Gain1_out1;  // sfix64_En31
  wire signed [31:0] not_ascii_1_out1;  // int32
  wire signed [31:0] not_ascii_2_out1;  // int32
  wire signed [63:0] Gain_out1;  // sfix64_En33
  wire signed [63:0] Sum_add_cast;  // sfix64_En31
  wire signed [63:0] Sum_out1;  // sfix64_En31
  wire signed [127:0] volumn_ctrl_cast;  // sfix128_En94
  wire signed [31:0] volumn_ctrl_out1;  // int32


  assign Gain1_out1 = 32'sb01100110011001100110011001100110 * In1;



  assign not_ascii_1_out1 = 32'sb00000000000000000000000000000000;



  assign not_ascii_2_out1 = 32'sb00000000000000000000000000000000;



  assign Gain_out1 = 32'sb01100110011001100110011001100110 * not_ascii_2_out1;



  assign Sum_add_cast = {{2{Gain_out1[63]}}, Gain_out1[63:2]};
  assign Sum_out1 = Gain1_out1 + Sum_add_cast;



  assign volumn_ctrl_cast = {{2{Sum_out1[63]}}, {Sum_out1, 62'b00000000000000000000000000000000000000000000000000000000000000}};
  assign volumn_ctrl_out1 = ((volumn_ctrl_cast[127] == 1'b0) && (volumn_ctrl_cast[126:125] != 2'b00) ? 32'sb01111111111111111111111111111111 :
              ((volumn_ctrl_cast[127] == 1'b1) && (volumn_ctrl_cast[126:125] != 2'b11) ? 32'sb10000000000000000000000000000000 :
              $signed(volumn_ctrl_cast[125:94])));



  assign Out1 = volumn_ctrl_out1;

endmodule  // distortion
