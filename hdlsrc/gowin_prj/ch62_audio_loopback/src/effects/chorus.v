`timescale 1 ns / 1 ns

module chorus
          (clk,
           reset_n,
           clk_enable,
           In1,
           In2,
           ce_out,
           Out1);


  input   clk;
  input   reset_n;
  input   clk_enable;
  input   [15:0] In1;  // uint16
  input   [15:0] In2;  // uint16
  output  ce_out;
  output  [15:0] Out1;  // uint16


  wire enb;
  reg [15:0] Delay1_reg [0:63];  // ufix16 [64]
  reg [15:0] Delay1_reg_next [0:63];  // ufix16 [64]
  reg [15:0] Delay1_out1;  // uint16
  wire [31:0] Gain1_out1;  // ufix32_En16
  wire [31:0] Gain2_out1;  // ufix32_En16
  wire [31:0] Sum1_add_cast;  // ufix32
  wire [31:0] Sum1_add_cast_1;  // ufix32
  wire [31:0] Sum1_add_temp;  // ufix32
  wire [15:0] Sum1_out1;  // uint16
  reg signed [31:0] Delay1_t_0_0;  // int32
  reg signed [31:0] Delay1_t_0_1;  // int32
  reg signed [31:0] Delay1_t_1;  // int32


  assign enb = clk_enable;

  always @(posedge clk or negedge reset_n)
    begin : Delay1_process
      if (reset_n == 1'b0) begin
        for(Delay1_t_1 = 32'sd0; Delay1_t_1 <= 32'sd63; Delay1_t_1 = Delay1_t_1 + 32'sd1) begin
          Delay1_reg[Delay1_t_1] <= 16'b0000000000000000;
        end
      end
      else begin
        if (enb) begin
          for(Delay1_t_0_1 = 32'sd0; Delay1_t_0_1 <= 32'sd63; Delay1_t_0_1 = Delay1_t_0_1 + 32'sd1) begin
            Delay1_reg[Delay1_t_0_1] <= Delay1_reg_next[Delay1_t_0_1];
          end
        end
      end
    end

  always @* begin
    Delay1_out1 = Delay1_reg[63];
    Delay1_reg_next[0] = In1;

    for(Delay1_t_0_0 = 32'sd0; Delay1_t_0_0 <= 32'sd62; Delay1_t_0_0 = Delay1_t_0_0 + 32'sd1) begin
      Delay1_reg_next[Delay1_t_0_0 + 32'sd1] = Delay1_reg[Delay1_t_0_0];
    end

  end



  // assign Gain1_out1 = 16'b1011010011111110 * Delay1_out1;
    assign Gain1_out1 = Delay1_out1;



  // assign Gain2_out1 = 16'b1100110011001101 * In1;
    assign Gain2_out1 = In1;



  assign Sum1_add_cast = ({16'b0, Gain1_out1[31:16]}) + Gain1_out1[15];
  assign Sum1_add_cast_1 = ({16'b0, Gain2_out1[31:16]}) + Gain2_out1[15];
  assign Sum1_add_temp = Sum1_add_cast + Sum1_add_cast_1;
  // assign Sum1_out1 = (Sum1_add_temp[31:16] != 16'b0000000000000000 ? 16'b1111111111111111 :
  //             Sum1_add_temp[15:0]);

  assign Sum1_out1 = Sum1_add_temp[15:0];

  assign Out1 = Sum1_out1;

  assign ce_out = clk_enable;

endmodule  // chorus
