// -------------------------------------------------------------
// 
// File Name: hdlsrc/chorus/Cosine_HDL_Optimized.v
// Created: 2024-11-03 17:00:52
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
// -------------------------------------------------------------


// -------------------------------------------------------------
// 
// Module: Cosine_HDL_Optimized
// Source Path: chorus/Cosine HDL Optimized
// Hierarchy Level: 0
// Model version: 1.11
// 
// -------------------------------------------------------------

`timescale 1 ns / 1 ns

module Cosine_HDL_Optimized
          (u,
           x);


  input   [15:0] u;  // uint16
  output  signed [16:0] x;  // sfix17_En15


  wire signed [16:0] Sine;  // sfix17_En15


  sine_hdl u_sine_hdl (.In1(u),  // uint16
                       .y(Sine)  // sfix17_En15
                       );

  assign x = Sine;

endmodule  // Cosine_HDL_Optimized

