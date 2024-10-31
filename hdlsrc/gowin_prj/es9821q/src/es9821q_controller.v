module es9821q_controller (
    input wire clk,               // 系统时钟
    input wire rst_n,             // 低电平复位
    input wire [7:0] i2c_data_dac, // DAC的I2C数据
    input wire [7:0] i2c_data_adc, // ADC的I2C数据
    output wire scl_dac,
    inout wire sda_dac,
    output wire scl_adc,
    inout wire sda_adc,
    output wire i2s_sck_dac,
    output wire i2s_ws_dac,
    output wire i2s_sd_dac,
    output wire i2s_sck_adc,
    output wire i2s_ws_adc,
    output wire i2s_sd_adc,
    output wire rrst
);
    
    wire busy_adc;
    wire ack_error_adc;
    wire [31:0] audio_data_adc;  // 用于存储从 ADC 获取的 32 位音频数据
    wire [31:0] fifo_data_out;
    wire fifo_empty;
    wire fifo_full;
    wire fifo_wr_en;
    wire fifo_rd_en;

    reg [6:0] i2c_addr_dac; // DAC的I2C地址
    reg [6:0] i2c_addr_adc = 7'h40; // ADC的I2C地址
    reg [7:0] reg_addr;    // 寄存器地址

    reg start_signal_internal;

    // 复位完成后启动内部信号
    assign rrst = rst_n;
    
    // 添加复位同步和防抖逻辑
/* -----\/----- EXCLUDED -----\/-----
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rst_n_sync <= 0;
            rst_n_sync_d <= 0;
        end else begin
            rst_n_sync <= 1;
            rst_n_sync_d <= rst_n_sync;
        end
    end
 -----/\----- EXCLUDED -----/\----- */
    
    // 立即生成启动信号
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            start_signal_internal <= 0;
        end else begin
            start_signal_internal <= 1;  // 复位信号解除后立即触发启动
        end
    end

    // 实例化I2C控制模块（用于ADC）
    i2c_adc_controller i2c_adc_inst (
        .clk(clk),
        .reset(1'b1),             // 使用同步后的复位信号，低电平有效
        .start(start_signal_internal),     // 启动I2C传输的信号
        .addr(i2c_addr_adc),               // ADC的I2C地址
        .scl(scl_adc),
        .sda(sda_adc),
        .busy(busy_adc),
        .ack_error(ack_error_adc)          // 连接应答错误信号
    );

    // 实例化I2S控制模块（用于从ADC获取数据）
    i2s_adc_controller i2s_adc_inst (
        .clk(clk),
        .reset(rst_n),             // 使用同步后的复位信号，低电平有效
        .audio_data(audio_data_adc),       // 输出 32 位音频数据，连接到 FIFO
        .i2s_sck(i2s_sck_adc),
        .i2s_ws(i2s_ws_adc),
        .i2s_sd(i2s_sd_adc)
    );


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
        .rst_n(rst_n),             // 使用同步后的复位信号
        .bclk(i2s_sck_dac),
        .lrclk(i2s_ws_dac),
        .data(fifo_data_out)             // 连接到FIFO读出的数据
    );

    // 实例化 FIFO 模块
    audio_fifo audio_fifo_instance (
        .Data(audio_data_adc),           // input [31:0] Data 输入数据（来自 ADC 的 32 位数据）
        .Reset(rst_n),            // input Reset 复位信号，低电平有效
        .WrClk(i2s_sck_adc),             // 修改为使用 I2S 时钟作为写时钟
        .RdClk(i2s_sck_dac),             // 修改为使用 DAC 的 I2S 时钟作为读时钟
        .WrEn(fifo_wr_en),               // input WrEn 写使能信号
        .RdEn(fifo_rd_en),               // input RdEn 读使能信号
        .Wnum(),                         // output [8:0] Wnum 写入数据量指示（未使用）
        .Rnum(),                         // output [8:0] Rnum 读取数据量指示（未使用）
        .Almost_Empty(),                 // output Almost_Empty 几乎空信号（未使用）
        .Almost_Full(),                  // output Almost_Full 几乎满信号（未使用）
        .Q(fifo_data_out),               // output [31:0] Q 读出的数据
        .Empty(fifo_empty),              // output Empty FIFO 为空指示
        .Full(fifo_full)                 // output Full FIFO 已满指示
    );

    // 控制 FIFO 写入和读取信号
    assign fifo_wr_en = (!fifo_full && !busy_adc);  // 当 FIFO 未满且 ADC 正在传输时，允许写入
    assign fifo_rd_en = (!fifo_empty && !ack_error_adc); // 当 FIFO 非空且没有应答错误时，允许读取
endmodule
