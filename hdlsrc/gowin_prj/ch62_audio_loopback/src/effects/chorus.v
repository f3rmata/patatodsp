`timescale 1 ns / 1 ns

module chorus
  (
    input   clk,
    input   reset_n,
    input   clk_enable,
    input   [15:0] In1,    // uint16
    input   [5:0] In2,    // uint16
    output  ce_out,
    output  [15:0] Out1
  );

  // 延迟线
  reg signed [15:0] Delay1_reg [0:512];
  wire signed [15:0] Delay1_out1;
  wire signed [31:0] Gain1_out1;
  wire signed [31:0] Gain2_out1;
  wire signed [31:0] Sum1_add_temp;
  wire signed [15:0] Sum1_out1;

  // 局部变量
  integer i;

  assign ce_out = clk_enable;

  // 移位寄存器 更新延迟线方便一点
  always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
      // 复位时，清空延迟线
      for (i = 0; i < 63; i = i + 1) begin
        Delay1_reg[i] <= 16'b0;  // 清空延迟线
      end
    end else if (clk_enable) begin
      // 逐个更新延迟线，向右移位并插入新的 In1
      for (i = 0; i < In2; i = i + 1) begin
        Delay1_reg[i+1] <= Delay1_reg[i];  // 右移
      end
      Delay1_reg[0] <= In1;  // 将 In1 插入到延迟线的第一个位置
    end
  end


  assign Delay1_out1 = Delay1_reg[63];


  assign Gain1_out1 = $signed(16'b1011010011111110) * Delay1_out1;  // （有符号）
  assign Gain2_out1 = $signed(16'b1100110011001101) * In1;         // （有符号）


  assign Sum1_add_temp = $signed(Gain1_out1) + $signed(Gain2_out1);

  // 输出
  assign Sum1_out1 = Sum1_add_temp[15:0];  // （有符号）

  assign Out1 = Sum1_out1;

endmodule  // chorus
