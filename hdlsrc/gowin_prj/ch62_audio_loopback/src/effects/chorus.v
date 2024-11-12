`timescale 1 ns / 1 ns

module chorus
  (
    input   clk,
    input   reset_n,
    input   [15:0] audio_in,    // uint16
    input   [8:0] sin_mod,     // 9-bit sine wave for modulation
    output  [15:0] audio_out
  );

  // 参数定义增益因子
  parameter signed [15:0] GAIN_K = 16'hC000;    // -K 增益因子示例 (-0.5)
  parameter signed [15:0] GAIN_08 = 16'd19660;  // 0.6 in Q15 format

  // 延迟存储器：1024 个级
  reg signed [31:0] delay_reg [0:511];  // 使用 1024 个 32 位存储器

  // 写指针和读指针
  reg [9:0] write_ptr;  // 写指针，用于写入当前输入信号
  reg [9:0] read_ptr_1;   // 第一个读指针，用于从延迟存储器读取回声信号
  // 内部信号
  wire signed [31:0] audio_in_32;      // 将 16-bit 输入扩展到 32-bit
  wire signed [31:0] delayed_sample_1; // 从延迟存储器中读取的延迟信号 1
  wire signed [31:0] modulated_sample_1; // 对 delayed_sample_1 应用调制信号
  wire signed [31:0] gain_mult_k_1;    // 增益 -K 结果 1
  wire signed [31:0] sum1;             // 第一次求和结果

  // 符号扩展，将 16 位扩展为 32 位
  assign audio_in_32 = $signed(audio_in);

  // 写指针控制
  always @(posedge clk or negedge reset_n) begin
      if (!reset_n) begin
          write_ptr <= 10'd0;
      end else begin
          write_ptr <= write_ptr + 1'b1;
      end
  end

  // 读指针控制（延迟不同的时间）
  always @(posedge clk or negedge reset_n) begin
      if (!reset_n) begin
          read_ptr_1 <= 10'd0;
      end else begin
          read_ptr_1 <= write_ptr - 10'd200;  // 延迟 200 个周期，形成回声效果
      end
  end

  // 延迟存储器写入
  always @(posedge clk) begin
      delay_reg[write_ptr] <= audio_in_32;  // 写入扩展后的 32-bit 输入信号
  end

  // 从延迟存储器中读取数据
  assign delayed_sample_1 = delay_reg[read_ptr_1];

  // 求和运算
  assign sum1 = audio_in_32 + gain_mult_k_1;  // 第一次求和

  // 对求和结果进行截断，输出 16 位音频信号
    assign audio_out = audio_in;  // 截断高位，保持16 位输出

endmodule  // chorus_g
