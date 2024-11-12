// -------------------------------------------------------------
//
// File Name: hdlsrc/distortion/distortion.v
// Created: 2024-11-09 00:34:52
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
// Model version: 1.3
//
// -------------------------------------------------------------

`timescale 1 ns / 1 ns

module distortion
  (In1,
   Drive,
   Out1);


    input wire signed [15:0] In1;  // int16
    input wire signed [15:0] Drive;  // int16
    output wire signed [15:0] Out1;  // int16

    reg signed [31:0]         boost_wave = 0;
    reg signed [31:0]         cut_wave = 0;
    reg signed [31:0]         gain_wave = 0;

    always @(*) begin
        boost_wave = In1 * 384 >>> 4;
        if (boost_wave >= 16'd65534 - Drive)
          begin
              cut_wave = 16'd65534 - Drive;
              gain_wave = cut_wave;
          end
        else if (boost_wave <= -65534 + Drive)
            begin
                cut_wave = -65534 + Drive;
                gain_wave = cut_wave;
            end
        else begin
            cut_wave = boost_wave;
            gain_wave = cut_wave;
        end
    end
    // assign Out1 = volumn_ctrl_out1;
    assign Out1 = gain_wave;

endmodule  // distortion
