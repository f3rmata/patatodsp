// -------------------------------------------------------------
// 
// File Name: hdlsrc/reverb_fdn/reverb_fdn.v
// Created: 2024-11-10 17:20:04
// 
// Generated by MATLAB 24.1, HDL Coder 24.1, and Simulink 24.1
// 
// 
// -- -------------------------------------------------------------
// -- Rate and Clocking Details
// -- -------------------------------------------------------------
// Model base rate: 0.16
// Target subsystem base rate: 0.16
// 
// 
// Clock Enable  Sample Time
// -- -------------------------------------------------------------
// ce_out        0.16
// -- -------------------------------------------------------------
// 
// 
// Output Signal                 Clock Enable  Sample Time
// -- -------------------------------------------------------------
// Out1                          ce_out        0.16
// -- -------------------------------------------------------------
// 
// -------------------------------------------------------------


// -------------------------------------------------------------
// 
// Module: reverb_fdn
// Source Path: reverb_fdn
// Hierarchy Level: 0
// Model version: 1.23
// 
// -------------------------------------------------------------

`timescale 1 ns / 1 ns

module reverb_fdn
          (clk,
           reset_n,
           clk_enable,
           In1,
           ce_out,
           Out1);


  input   clk;
  input   reset_n;
  input   clk_enable;
  input   [15:0] In1;  // uint16
  output  ce_out;
  output  [15:0] Out1;  // uint16


  wire enb;
  wire [31:0] Gain4_out1;  // ufix32_En16
  wire [15:0] c32_Constant_out1 [0:15];  // uint16 [16]
  wire [15:0] Constant_out1 [0:3] [0:3];  // uint16 [4x4]
  wire [15:0] s [0:15];  // uint16 [16]
  wire [15:0] selector_out [0:15];  // uint16 [16]
  wire [15:0] s_1 [0:15];  // uint16 [16]
  wire [31:0] Gain5_out1;  // ufix32_En17
  wire [31:0] Gain6_out1;  // ufix32_En19
  wire [31:0] Gain7_out1;  // ufix32_En21
  wire [31:0] reshape_out [0:3] [0:3];  // uint32 [4x4]
  wire [31:0] selector_out_1 [0:3];  // uint32 [4]
  wire [31:0] selector_out_2 [0:3];  // uint32 [4]
  wire [31:0] selector_out_3 [0:3];  // uint32 [4]
  wire [31:0] Product_out1 [0:3];  // uint32 [4]
  wire [31:0] Product_out1_0;  // uint32
  wire [31:0] Sum3_add_cast;  // ufix32
  wire [31:0] Sum3_out1;  // uint32
  reg [31:0] Delay3_reg [0:159];  // ufix32 [160]
  reg [31:0] Delay3_reg_next [0:159];  // ufix32 [160]
  reg [31:0] Delay3_out1;  // uint32
  wire [63:0] Gain3_mul_temp;  // ufix64_En35
  wire [15:0] Gain3_out1;  // uint16
  wire [31:0] Product_out1_1;  // uint32
  wire [31:0] Sum2_add_cast;  // ufix32
  wire [31:0] Sum2_out1;  // uint32
  reg [31:0] Delay2_reg [0:79];  // ufix32 [80]
  reg [31:0] Delay2_reg_next [0:79];  // ufix32 [80]
  reg [31:0] Delay2_out1;  // uint32
  wire [63:0] Gain2_mul_temp;  // ufix64_En34
  wire [15:0] Gain2_out1;  // uint16
  wire [31:0] Product_out1_2;  // uint32
  wire [31:0] Sum1_add_cast;  // ufix32
  wire [31:0] Sum1_out1;  // uint32
  reg [31:0] Delay1_reg [0:39];  // ufix32 [40]
  reg [31:0] Delay1_reg_next [0:39];  // ufix32 [40]
  reg [31:0] Delay1_out1;  // uint32
  wire [63:0] Gain1_mul_temp;  // ufix64_En33
  wire [15:0] Gain1_out1;  // uint16
  reg [31:0] Delay_out1;  // uint32
  wire [63:0] Gain_mul_temp;  // ufix64_En32
  wire [15:0] Gain_out1;  // uint16
  wire [15:0] selector_out_4 [0:15];  // uint16 [16]
  wire [15:0] s_2 [0:15];  // uint16 [16]
  wire [31:0] MMul_dot_product_out [0:15];  // uint32 [16]
  wire [31:0] selector_out_5 [0:3];  // uint32 [4]
  wire [32:0] MMul_add_01_add_temp [0:3];  // ufix33 [4]
  wire [32:0] MMul_add_01_1 [0:3];  // ufix33 [4]
  wire [32:0] MMul_add_01_2 [0:3];  // ufix33 [4]
  wire [31:0] MMul_add_01_out [0:3];  // uint32 [4]
  wire [32:0] MMul_add_12_add_temp [0:3];  // ufix33 [4]
  wire [32:0] MMul_add_12_1 [0:3];  // ufix33 [4]
  wire [32:0] MMul_add_12_2 [0:3];  // ufix33 [4]
  wire [31:0] MMul_add_12_out [0:3];  // uint32 [4]
  wire [32:0] MMul_add_23_add_temp [0:3];  // ufix33 [4]
  wire [32:0] MMul_add_23_1 [0:3];  // ufix33 [4]
  wire [32:0] MMul_add_23_2 [0:3];  // ufix33 [4]
  wire [31:0] s_3 [0:3];  // uint32 [4]
  wire [31:0] Product_out1_3;  // uint32
  wire [31:0] Sum_add_cast;  // ufix32
  wire [31:0] Sum_out1;  // uint32
  reg [31:0] Delay_reg [0:19];  // ufix32 [20]
  reg [31:0] Delay_reg_next [0:19];  // ufix32 [20]
  wire [63:0] Gain8_out1;  // ufix64_En31
  wire [63:0] Gain9_out1;  // ufix64_En31
  wire [63:0] Sum4_out1;  // ufix64_En31
  wire [63:0] Gain10_out1;  // ufix64_En31
  wire [63:0] Sum5_out1;  // ufix64_En31
  wire [63:0] Gain11_out1;  // ufix64_En31
  wire [63:0] Sum6_out1;  // ufix64_En31
  wire [127:0] Gain13_out1;  // ufix128_En95
  wire [31:0] Gain12_out1;  // ufix32_En16
  wire [127:0] Sum7_add_cast;  // ufix128_En95
  wire [127:0] Sum7_out1;  // ufix128_En95
  wire [15:0] Data_Type_Conversion_out1;  // uint16
  reg signed [31:0] Delay3_t_0_0;  // int32
  reg signed [31:0] Delay3_t_0_1;  // int32
  reg signed [31:0] Delay3_t_1;  // int32
  reg signed [31:0] Delay2_t_0_0;  // int32
  reg signed [31:0] Delay2_t_0_1;  // int32
  reg signed [31:0] Delay2_t_1;  // int32
  reg signed [31:0] Delay1_t_0_0;  // int32
  reg signed [31:0] Delay1_t_0_1;  // int32
  reg signed [31:0] Delay1_t_1;  // int32
  reg signed [31:0] Delay_t_0_0;  // int32
  reg signed [31:0] Delay_t_0_1;  // int32
  reg signed [31:0] Delay_t_1;  // int32


  assign Gain4_out1 = 16'b1100110011001101 * In1;



  assign c32_Constant_out1[0] = 16'b0000000000000001;
  assign c32_Constant_out1[1] = 16'b0000000000000001;
  assign c32_Constant_out1[2] = 16'b0000000000000001;
  assign c32_Constant_out1[3] = 16'b0000000000000001;
  assign c32_Constant_out1[4] = 16'b0000000000000001;
  assign c32_Constant_out1[5] = 16'b0000000000000000;
  assign c32_Constant_out1[6] = 16'b0000000000000001;
  assign c32_Constant_out1[7] = 16'b0000000000000000;
  assign c32_Constant_out1[8] = 16'b0000000000000001;
  assign c32_Constant_out1[9] = 16'b0000000000000001;
  assign c32_Constant_out1[10] = 16'b0000000000000000;
  assign c32_Constant_out1[11] = 16'b0000000000000000;
  assign c32_Constant_out1[12] = 16'b0000000000000001;
  assign c32_Constant_out1[13] = 16'b0000000000000000;
  assign c32_Constant_out1[14] = 16'b0000000000000000;
  assign c32_Constant_out1[15] = 16'b0000000000000001;



  generate
    genvar idx8;
    for(idx8 = 0; idx8 < 4; idx8 = idx8 + 1) begin : Constant_out1_gen1
      genvar idx7;
      for(idx7 = 0; idx7 < 4; idx7 = idx7 + 1) begin : Constant_out1_gen
        assign Constant_out1[idx7][idx8] = c32_Constant_out1[idx7 + (idx8 * 4)];
      end
    end
  endgenerate

  generate
    genvar idx6;
    for(idx6 = 0; idx6 < 4; idx6 = idx6 + 1) begin : s_gen1
      genvar idx5;
      for(idx5 = 0; idx5 < 4; idx5 = idx5 + 1) begin : s_gen
        assign s[idx5 + (idx6 * 4)] = Constant_out1[idx5][idx6];
      end
    end
  endgenerate

  assign selector_out[0] = s[0];
  assign selector_out[1] = s[4];
  assign selector_out[2] = s[8];
  assign selector_out[3] = s[12];
  assign selector_out[4] = s[1];
  assign selector_out[5] = s[5];
  assign selector_out[6] = s[9];
  assign selector_out[7] = s[13];
  assign selector_out[8] = s[2];
  assign selector_out[9] = s[6];
  assign selector_out[10] = s[10];
  assign selector_out[11] = s[14];
  assign selector_out[12] = s[3];
  assign selector_out[13] = s[7];
  assign selector_out[14] = s[11];
  assign selector_out[15] = s[15];

  generate
    genvar idx4;
    for(idx4 = 0; idx4 < 16; idx4 = idx4 + 1) begin : s_1_gen
      assign s_1[idx4] = selector_out[idx4];
    end
  endgenerate

  assign Gain5_out1 = 16'b1100110011001101 * In1;



  assign enb = clk_enable;

  assign Gain6_out1 = 16'b1100110011001101 * In1;



  assign Gain7_out1 = 16'b1100110011001101 * In1;




  genvar t_0_08;
  generate
    for(t_0_08 = 32'sd0; t_0_08 <= 32'sd3; t_0_08 = t_0_08 + 32'sd1) begin:selector_out_1_gen
      assign selector_out_1[t_0_08] = reshape_out[3][t_0_08];
    end
  endgenerate





  genvar t_0_011;
  generate
    for(t_0_011 = 32'sd0; t_0_011 <= 32'sd3; t_0_011 = t_0_011 + 32'sd1) begin:selector_out_2_gen
      assign selector_out_2[t_0_011] = reshape_out[2][t_0_011];
    end
  endgenerate





  genvar t_0_021;
  generate
    for(t_0_021 = 32'sd0; t_0_021 <= 32'sd3; t_0_021 = t_0_021 + 32'sd1) begin:selector_out_3_gen
      assign selector_out_3[t_0_021] = reshape_out[1][t_0_021];
    end
  endgenerate




  assign Product_out1_0 = Product_out1[0];

  assign Sum3_add_cast = {21'b0, Gain7_out1[31:21]};
  assign Sum3_out1 = Sum3_add_cast + Product_out1_0;



  always @(posedge clk or negedge reset_n)
    begin : Delay3_process
      if (reset_n == 1'b0) begin
        for(Delay3_t_1 = 32'sd0; Delay3_t_1 <= 32'sd159; Delay3_t_1 = Delay3_t_1 + 32'sd1) begin
          Delay3_reg[Delay3_t_1] <= 32'b00000000000000000000000000000000;
        end
      end
      else begin
        if (enb) begin
          for(Delay3_t_0_1 = 32'sd0; Delay3_t_0_1 <= 32'sd159; Delay3_t_0_1 = Delay3_t_0_1 + 32'sd1) begin
            Delay3_reg[Delay3_t_0_1] <= Delay3_reg_next[Delay3_t_0_1];
          end
        end
      end
    end

  always @* begin
    Delay3_out1 = Delay3_reg[159];
    Delay3_reg_next[0] = Sum3_out1;

    for(Delay3_t_0_0 = 32'sd0; Delay3_t_0_0 <= 32'sd158; Delay3_t_0_0 = Delay3_t_0_0 + 32'sd1) begin
      Delay3_reg_next[Delay3_t_0_0 + 32'sd1] = Delay3_reg[Delay3_t_0_0];
    end

  end



  assign Gain3_mul_temp = 32'b11010111000010100011110101110001 * Delay3_out1;
  assign Gain3_out1 = (Gain3_mul_temp[63:51] != 13'b0000000000000 ? 16'b1111111111111111 :
              Gain3_mul_temp[50:35]);



  assign Product_out1_1 = Product_out1[1];

  assign Sum2_add_cast = {19'b0, Gain6_out1[31:19]};
  assign Sum2_out1 = Sum2_add_cast + Product_out1_1;



  always @(posedge clk or negedge reset_n)
    begin : Delay2_process
      if (reset_n == 1'b0) begin
        for(Delay2_t_1 = 32'sd0; Delay2_t_1 <= 32'sd79; Delay2_t_1 = Delay2_t_1 + 32'sd1) begin
          Delay2_reg[Delay2_t_1] <= 32'b00000000000000000000000000000000;
        end
      end
      else begin
        if (enb) begin
          for(Delay2_t_0_1 = 32'sd0; Delay2_t_0_1 <= 32'sd79; Delay2_t_0_1 = Delay2_t_0_1 + 32'sd1) begin
            Delay2_reg[Delay2_t_0_1] <= Delay2_reg_next[Delay2_t_0_1];
          end
        end
      end
    end

  always @* begin
    Delay2_out1 = Delay2_reg[79];
    Delay2_reg_next[0] = Sum2_out1;

    for(Delay2_t_0_0 = 32'sd0; Delay2_t_0_0 <= 32'sd78; Delay2_t_0_0 = Delay2_t_0_0 + 32'sd1) begin
      Delay2_reg_next[Delay2_t_0_0 + 32'sd1] = Delay2_reg[Delay2_t_0_0];
    end

  end



  assign Gain2_mul_temp = 32'b11010111000010100011110101110001 * Delay2_out1;
  assign Gain2_out1 = (Gain2_mul_temp[63:50] != 14'b00000000000000 ? 16'b1111111111111111 :
              Gain2_mul_temp[49:34]);



  assign Product_out1_2 = Product_out1[2];

  assign Sum1_add_cast = {17'b0, Gain5_out1[31:17]};
  assign Sum1_out1 = Sum1_add_cast + Product_out1_2;



  always @(posedge clk or negedge reset_n)
    begin : Delay1_process
      if (reset_n == 1'b0) begin
        for(Delay1_t_1 = 32'sd0; Delay1_t_1 <= 32'sd39; Delay1_t_1 = Delay1_t_1 + 32'sd1) begin
          Delay1_reg[Delay1_t_1] <= 32'b00000000000000000000000000000000;
        end
      end
      else begin
        if (enb) begin
          for(Delay1_t_0_1 = 32'sd0; Delay1_t_0_1 <= 32'sd39; Delay1_t_0_1 = Delay1_t_0_1 + 32'sd1) begin
            Delay1_reg[Delay1_t_0_1] <= Delay1_reg_next[Delay1_t_0_1];
          end
        end
      end
    end

  always @* begin
    Delay1_out1 = Delay1_reg[39];
    Delay1_reg_next[0] = Sum1_out1;

    for(Delay1_t_0_0 = 32'sd0; Delay1_t_0_0 <= 32'sd38; Delay1_t_0_0 = Delay1_t_0_0 + 32'sd1) begin
      Delay1_reg_next[Delay1_t_0_0 + 32'sd1] = Delay1_reg[Delay1_t_0_0];
    end

  end



  assign Gain1_mul_temp = 32'b11010111000010100011110101110001 * Delay1_out1;
  assign Gain1_out1 = (Gain1_mul_temp[63:49] != 15'b000000000000000 ? 16'b1111111111111111 :
              Gain1_mul_temp[48:33]);



  assign Gain_mul_temp = 32'b11010111000010100011110101110001 * Delay_out1;
  assign Gain_out1 = (Gain_mul_temp[63:48] != 16'b0000000000000000 ? 16'b1111111111111111 :
              Gain_mul_temp[47:32]);



  assign selector_out_4[0] = Gain_out1;
  assign selector_out_4[1] = Gain1_out1;
  assign selector_out_4[2] = Gain2_out1;
  assign selector_out_4[3] = Gain3_out1;
  assign selector_out_4[4] = Gain_out1;
  assign selector_out_4[5] = Gain1_out1;
  assign selector_out_4[6] = Gain2_out1;
  assign selector_out_4[7] = Gain3_out1;
  assign selector_out_4[8] = Gain_out1;
  assign selector_out_4[9] = Gain1_out1;
  assign selector_out_4[10] = Gain2_out1;
  assign selector_out_4[11] = Gain3_out1;
  assign selector_out_4[12] = Gain_out1;
  assign selector_out_4[13] = Gain1_out1;
  assign selector_out_4[14] = Gain2_out1;
  assign selector_out_4[15] = Gain3_out1;

  generate
    genvar idx3;
    for(idx3 = 0; idx3 < 16; idx3 = idx3 + 1) begin : s_2_gen
      assign s_2[idx3] = selector_out_4[idx3];
    end
  endgenerate


  genvar t_0_031;
  generate
    for(t_0_031 = 32'sd0; t_0_031 <= 32'sd15; t_0_031 = t_0_031 + 32'sd1) begin:MMul_dot_product_out_gen
      assign MMul_dot_product_out[t_0_031] = s_1[t_0_031] * s_2[t_0_031];
    end
  endgenerate




  generate
    genvar idx2;
    for(idx2 = 0; idx2 < 4; idx2 = idx2 + 1) begin : reshape_out_gen1
      genvar idx1;
      for(idx1 = 0; idx1 < 4; idx1 = idx1 + 1) begin : reshape_out_gen
        assign reshape_out[idx1][idx2] = MMul_dot_product_out[idx1 + (idx2 * 4)];
      end
    end
  endgenerate


  genvar t_0_041;
  generate
    for(t_0_041 = 32'sd0; t_0_041 <= 32'sd3; t_0_041 = t_0_041 + 32'sd1) begin:selector_out_5_gen
      assign selector_out_5[t_0_041] = reshape_out[0][t_0_041];
    end
  endgenerate





  genvar t_0_051;
  generate
    for(t_0_051 = 32'sd0; t_0_051 <= 32'sd3; t_0_051 = t_0_051 + 32'sd1) begin:MMul_add_01_out_gen
      assign MMul_add_01_1[t_0_051] = {1'b0, selector_out_5[t_0_051]};
      assign MMul_add_01_2[t_0_051] = {1'b0, selector_out_3[t_0_051]};
      assign MMul_add_01_add_temp[t_0_051] = MMul_add_01_1[t_0_051] + MMul_add_01_2[t_0_051];
      assign MMul_add_01_out[t_0_051] = (MMul_add_01_add_temp[t_0_051][32] != 1'b0 ? 32'b11111111111111111111111111111111 :
                  MMul_add_01_add_temp[t_0_051][31:0]);
    end
  endgenerate





  genvar t_0_061;
  generate
    for(t_0_061 = 32'sd0; t_0_061 <= 32'sd3; t_0_061 = t_0_061 + 32'sd1) begin:MMul_add_12_out_gen
      assign MMul_add_12_1[t_0_061] = {1'b0, MMul_add_01_out[t_0_061]};
      assign MMul_add_12_2[t_0_061] = {1'b0, selector_out_2[t_0_061]};
      assign MMul_add_12_add_temp[t_0_061] = MMul_add_12_1[t_0_061] + MMul_add_12_2[t_0_061];
      assign MMul_add_12_out[t_0_061] = (MMul_add_12_add_temp[t_0_061][32] != 1'b0 ? 32'b11111111111111111111111111111111 :
                  MMul_add_12_add_temp[t_0_061][31:0]);
    end
  endgenerate





  genvar t_0_071;
  generate
    for(t_0_071 = 32'sd0; t_0_071 <= 32'sd3; t_0_071 = t_0_071 + 32'sd1) begin:s_3_gen
      assign MMul_add_23_1[t_0_071] = {1'b0, MMul_add_12_out[t_0_071]};
      assign MMul_add_23_2[t_0_071] = {1'b0, selector_out_1[t_0_071]};
      assign MMul_add_23_add_temp[t_0_071] = MMul_add_23_1[t_0_071] + MMul_add_23_2[t_0_071];
      assign s_3[t_0_071] = (MMul_add_23_add_temp[t_0_071][32] != 1'b0 ? 32'b11111111111111111111111111111111 :
                  MMul_add_23_add_temp[t_0_071][31:0]);
    end
  endgenerate




  generate
    genvar idx;
    for(idx = 0; idx < 4; idx = idx + 1) begin : Product_out1_gen
      assign Product_out1[idx] = s_3[idx];
    end
  endgenerate

  assign Product_out1_3 = Product_out1[3];

  assign Sum_add_cast = {16'b0, Gain4_out1[31:16]};
  assign Sum_out1 = Sum_add_cast + Product_out1_3;



  always @(posedge clk or negedge reset_n)
    begin : Delay_process
      if (reset_n == 1'b0) begin
        for(Delay_t_1 = 32'sd0; Delay_t_1 <= 32'sd19; Delay_t_1 = Delay_t_1 + 32'sd1) begin
          Delay_reg[Delay_t_1] <= 32'b00000000000000000000000000000000;
        end
      end
      else begin
        if (enb) begin
          for(Delay_t_0_1 = 32'sd0; Delay_t_0_1 <= 32'sd19; Delay_t_0_1 = Delay_t_0_1 + 32'sd1) begin
            Delay_reg[Delay_t_0_1] <= Delay_reg_next[Delay_t_0_1];
          end
        end
      end
    end

  always @* begin
    Delay_out1 = Delay_reg[19];
    Delay_reg_next[0] = Sum_out1;

    for(Delay_t_0_0 = 32'sd0; Delay_t_0_0 <= 32'sd18; Delay_t_0_0 = Delay_t_0_0 + 32'sd1) begin
      Delay_reg_next[Delay_t_0_0 + 32'sd1] = Delay_reg[Delay_t_0_0];
    end

  end



  assign Gain8_out1 = {1'b0, {Delay_out1, 31'b0000000000000000000000000000000}};



  assign Gain9_out1 = {1'b0, {Delay1_out1, 31'b0000000000000000000000000000000}};



  assign Sum4_out1 = Gain8_out1 + Gain9_out1;



  assign Gain10_out1 = {1'b0, {Delay2_out1, 31'b0000000000000000000000000000000}};



  assign Sum5_out1 = Sum4_out1 + Gain10_out1;



  assign Gain11_out1 = {1'b0, {Delay3_out1, 31'b0000000000000000000000000000000}};



  assign Sum6_out1 = Sum5_out1 + Gain11_out1;



  assign Gain13_out1 = 64'hCCCCCCCCCCCCD000 * Sum6_out1;



  assign Gain12_out1 = {1'b0, {In1, 15'b000000000000000}};



  assign Sum7_add_cast = {17'b0, {Gain12_out1, 79'b0000000000000000000000000000000000000000000000000000000000000000000000000000000}};
  assign Sum7_out1 = Gain13_out1 + Sum7_add_cast;



  assign Data_Type_Conversion_out1 = Sum7_out1[110:95];



  assign Out1 = Data_Type_Conversion_out1;

  assign ce_out = clk_enable;

endmodule  // reverb_fdn
