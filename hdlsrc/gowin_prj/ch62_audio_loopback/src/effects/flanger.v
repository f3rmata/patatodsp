`timescale 1 ns / 1 ns

module flanger (
    input clk,
    input reset_n,
    input clk_enable,
    input [5:0] delay,
    input signed [15:0] In1,  // int16
    output signed [15:0] Out1  // int16
);

    // 参数定义增益因子
    parameter signed [15:0] GAIN_K = 16'hB000;    // -K 增益因子
    parameter signed [15:0] GAIN_04 = 16'd13107;  // 0.4 in Q15 format (0.4 * 32768)
    parameter signed [15:0] GAIN_08 = 16'd26214;  // 0.8 in Q15 format (0.8 * 32768)

    // 延迟寄存器：256 个级
    reg signed [31:0] delay_reg [0:1023];  // 使用 1024 个 32 位寄存器

    // 写指针和读指针
    reg [7:0] write_ptr;  // 写指针，用于写入当前输入信号
    reg [7:0] read_ptr;   // 读指针，用于从延迟寄存器读取信号

    // 内部信号
    wire signed [31:0] In1_32;            // 将 16-bit 输入扩展到 32-bit
    wire signed [31:0] delayed_sample;    // 从延迟寄存器中读取的延迟信号
    wire signed [31:0] gain_mult_k;       // 增益 -K 结果
    wire signed [31:0] sum1;              // 第一次求和结果
    wire signed [31:0] gain_mult_04;      // 增益 0.4 结果
    wire signed [31:0] sum2;              // 第二次求和结果
    wire signed [31:0] gain_mult_08;      // 增益 0.8 结果
    wire signed [31:0] sum3;              // 最终求和结果

    // 符号扩展，将 16 位扩展为 32 位
    assign In1_32 = $signed(In1);

    // 写指针控制
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            write_ptr <= 8'd0;
        end else if (clk_enable) begin
            write_ptr <= write_ptr + 1'b1;
        end
    end

    // 读指针控制（与写指针延迟）
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            read_ptr <= 8'd0;
        end else if (clk_enable) begin
            read_ptr <= write_ptr - delay;  // 延迟一定的周期，形成镶边效果
        end
    end

    // 延迟寄存器写入
    always @(posedge clk) begin
        if (clk_enable) begin
            delay_reg[write_ptr] <= In1_32;  // 写入扩展后的 32-bit 输入信号
        end
    end

    // 从延迟寄存器中读取数据
    assign delayed_sample = delay_reg[read_ptr];

    // 对延迟信号应用增益 -K
    assign gain_mult_k = (delayed_sample * GAIN_K) >>> 15;  // 乘以负增益因子

    // 第一次求和：输入信号与增益 -K 的延迟信号相加
    assign sum1 = In1_32 + gain_mult_k;

    // 对延迟信号应用增益 0.4
    assign gain_mult_04 = (delayed_sample * GAIN_04) >>> 15;  // Q15 格式乘法

    // 第二次求和：将增益 0.4 的延迟信号与 sum1 相加
    assign sum2 = sum1 + gain_mult_04;

    // 对延迟信号应用增益 0.8
    assign gain_mult_08 = (delayed_sample * GAIN_08) >>> 15;  // Q15 格式乘法

    // 最终求和：将增益 0.8 的延迟信号与 sum2 相加
    assign sum3 = sum2 + gain_mult_08;

    // 对最终结果进行截断，输出 16 位音频信号
    assign Out1 = sum3;  // 截断高位，保持 16 位输出


endmodule // flanger
