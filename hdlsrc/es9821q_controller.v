// FPGA Verilog 代码，使用 I2C 控制 ES9039Q2M DAC 和 ES9821Q ADC，音频数据通过 I2S 接口传输
// I2C 接口: SDA, SCL
// I2S 接口: BCLK, LRCLK, DATA

module es9821q_controller (
    input wire clk,               // 系统时钟
    input wire rst_n,             // 低电平复位
    input wire start_signal_pin,  // 连接至外部引脚以控制I2C启动
    input wire [6:0] i2c_addr_dac, // DAC的I2C地址
    input wire [6:0] i2c_addr_adc, // ADC的I2C地址
    input wire [7:0] reg_addr,    // 寄存器地址
    input wire [7:0] i2c_data_dac, // DAC的I2C数据
    input wire [7:0] i2c_data_adc, // ADC的I2C数据
    input wire [31:0] audio_data, // 修改为32位宽度
    output wire scl_dac,
    inout wire sda_dac,
    output wire scl_adc,
    inout wire sda_adc,
    output wire i2s_sck_dac,
    output wire i2s_ws_dac,
    output wire i2s_sd_dac,
    output wire i2s_sck_adc,
    output wire i2s_ws_adc,
    output wire i2s_sd_adc
);

    wire busy_adc;
    wire ack_error_adc;

    reg start_signal_internal;

    // 复位完成后启动内部信号
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin  // 复位完成或某个计数器达到特定值
            start_signal_internal <= 1;
        end else begin
            start_signal_internal <= 0;
        end
    end

    // 实例化I2C控制模块（用于DAC）
    i2c_dac_control i2c_dac_inst (
        .clk(clk),
        .rst_n(rst_n),
        .start_config(start_signal_internal),   // 需要一个启动I2C传输的信号
        .i2c_addr(i2c_addr_dac),
        .reg_addr(reg_addr),             // 添加寄存器地址输入
        .data(i2c_data_dac),
        .scl(scl_dac),
        .sda(sda_dac)
    );

    // 实例化I2S控制模块（用于DAC音频数据传输）
    i2s_dac_control i2s_dac_inst (
        .clk(clk),
        .rst_n(rst_n),                   // 使用rst_n作为复位信号
        .start_audio(start_signal_pin),  // 启动I2S音频传输的信号
        .bclk(i2s_sck_dac),
        .lrclk(i2s_ws_dac),
        .data(i2s_sd_dac)
    );

    // 实例化I2C控制模块（用于ADC）
    i2c_adc_controller i2c_adc_inst (
        .clk(clk),
        .reset(rst_n),                   // 使用rst_n作为复位信号
        .start(start_signal_internal),   // 启动I2C传输的信号
        .addr(i2c_addr_adc),             // ADC的I2C地址
        .reg_addr(reg_addr),             // 添加寄存器地址输入
        .data(i2c_data_adc),
        .scl(scl_adc),
        .sda(sda_adc),
        .busy(busy_adc),
        .ack_error(ack_error_adc)        // 连接应答错误信号
    );

    // 实例化I2S控制模块（用于从ADC获取数据）
    i2s_adc_controller i2s_adc_inst (
        .clk(clk),
        .reset(rst_n),                   // 使用rst_n作为复位信号
        .audio_data(audio_data),         // 使用32位音频数据
        .i2s_sck(i2s_sck_adc),
        .i2s_ws(i2s_ws_adc),
        .i2s_sd(i2s_sd_adc)
    );

endmodule // es9821q_controller
