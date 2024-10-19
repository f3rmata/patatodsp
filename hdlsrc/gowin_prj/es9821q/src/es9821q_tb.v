// es9821q_controller 模块的测试文件
`timescale 1ns / 1ps

module es9821q_tb;

    reg clk;
    reg rst_n;
    reg [6:0] i2c_addr_dac;
    reg [6:0] i2c_addr_adc;
    reg [7:0] reg_addr;
    reg [7:0] i2c_data_dac;
    reg [7:0] i2c_data_adc;
    wire scl_dac;
    wire sda_dac;
    wire scl_adc;
    wire sda_adc;
    wire i2s_sck_dac;
    wire i2s_ws_dac;
    wire i2s_sd_dac;
    wire i2s_sck_adc;
    wire i2s_ws_adc;
    wire i2s_sd_adc;

    // 实例化被测试的模块
    es9821q_controller uut (
        .clk(clk),
        .rst_n(rst_n),
        .i2c_addr_dac(i2c_addr_dac),
        .i2c_addr_adc(i2c_addr_adc),
        .reg_addr(reg_addr),
        .i2c_data_dac(i2c_data_dac),
        .i2c_data_adc(i2c_data_adc),
        .scl_dac(scl_dac),
        .sda_dac(sda_dac),
        .scl_adc(scl_adc),
        .sda_adc(sda_adc),
        .i2s_sck_dac(i2s_sck_dac),
        .i2s_ws_dac(i2s_ws_dac),
        .i2s_sd_dac(i2s_sd_dac),
        .i2s_sck_adc(i2s_sck_adc),
        .i2s_ws_adc(i2s_ws_adc),
        .i2s_sd_adc(i2s_sd_adc)
    );

    // 时钟信号生成
    always #5 clk = ~clk;  // 生成周期为 10 ns 的时钟

    initial begin
        // 初始化输入信号
        clk = 0;
        rst_n = 0;
        i2c_addr_dac = 7'h1A;
        i2c_addr_adc = 7'h2B;
        reg_addr = 8'h00;
        i2c_data_dac = 8'hAA;
        i2c_data_adc = 8'hBB;

        // 复位设计
        #10 rst_n = 1;

        // 为 I2C 和 I2S 通信产生激励信号
        #100 reg_addr = 8'h10;  // 设置寄存器地址
        #50 i2c_data_dac = 8'h55; // 设置 DAC 数据
        #50 i2c_data_adc = 8'h77; // 设置 ADC 数据

        // 等待一段时间以观察行为
        #500;

        // 结束仿真
        $stop;
    end

endmodule
