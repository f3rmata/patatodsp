// FPGA Verilog 代码，使用 I2C 控制 ES9039Q2M DAC，音频数据通过 I2S 接口传输
// I2C 接口: SDA, SCL
// I2S 接口: BCLK, LRCLK, DATA

module dac_controller (
    input wire clk,               // 系统时钟
    input wire rst_n,             // 低电平复位
    // I2C 接口
    inout wire sda,               // I2C 数据线
    output reg scl,               // I2C 时钟线
    input wire start_config,      // 启动 I2C 配置的信号
    // I2S 接口
    output reg bclk,              // I2S 比特时钟
    output reg lrclk,             // I2S 左右声道时钟
    output reg data,              // I2S 数据线
    input wire start_audio        // 启动 I2S 音频传输的信号
);

    // I2C 参数
    localparam I2C_IDLE      = 3'd0;   // I2C 空闲状态
    localparam I2C_START     = 3'd1;   // I2C 起始条件状态
    localparam I2C_ADDR      = 3'd2;   // I2C 发送地址状态
    localparam I2C_WRITE_REG = 3'd3;   // I2C 发送寄存器地址状态
    localparam I2C_WRITE_DATA = 3'd4;  // I2C 发送数据状态
    localparam I2C_STOP      = 3'd5;   // I2C 停止条件状态

    reg [2:0] i2c_state;          // 当前 I2C 状态机的状态
    reg [7:0] i2c_data;           // 通过 I2C 发送的数据
    reg [3:0] bit_counter;        // 位计数器，用于跟踪正在传输的位数

    // SDA 输出逻辑
    reg sda_out;
    assign sda = (sda_out) ? 1'bz : 1'b0;

    // I2S 参数
    localparam I2S_IDLE      = 2'd0;   // I2S 空闲状态
    localparam I2S_START     = 2'd1;   // I2S 起始状态
    localparam I2S_TRANSFER  = 2'd2;   // I2S 传输状态

    reg [1:0] i2s_state;          // 当前 I2S 状态机的状态
    reg [31:0] audio_data;        // 通过 I2S 发送的音频数据（32 位）
    reg [5:0] i2s_bit_counter;    // I2S 位计数器

    // 音频数据缓冲区，用于存储从 SPI 接收到的音频数据
    reg [31:0] audio_buffer [0:255]; // 音频数据缓冲区
    reg [7:0] audio_index;        // 当前音频数据索引

    // SPI 接收的数据寄存器
    reg [31:0] spi_received_data;
    reg spi_data_valid;

    // I2C 控制的状态机
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i2c_state <= I2C_IDLE;    // 复位时进入空闲状态
            scl <= 1;                 // SCL 设置为高电平（空闲状态）
            sda_out <= 1;             // SDA 设置为高电平（空闲状态）
            bit_counter <= 4'd0;      // 复位位计数器
        end else begin
            case (i2c_state)
                I2C_IDLE: begin
                    if (start_config) begin
                        i2c_state <= I2C_START;
                        scl <= 1;
                        sda_out <= 0;  // 起始条件（SDA 拉低）
                    end
                end
                
                I2C_START: begin
                    scl <= 0;      // 准备发送地址
                    i2c_data <= 8'h4A;  // 示例 I2C 地址
                    bit_counter <= 4'd7;
                    i2c_state <= I2C_ADDR;
                end
                
                I2C_ADDR: begin
                    scl <= ~scl;
                    if (scl) begin
                        sda_out <= i2c_data[bit_counter];  // 发送 I2C 地址的每一位
                        bit_counter <= bit_counter - 1;
                        if (bit_counter == 0) begin
                            i2c_state <= I2C_WRITE_REG;
                            i2c_data <= 8'h00;  // 要配置的寄存器地址
                            bit_counter <= 4'd7;
                        end
                    end
                end
                
                I2C_WRITE_REG: begin
                    scl <= ~scl;
                    if (scl) begin
                        sda_out <= i2c_data[bit_counter];  // 发送寄存器地址的每一位
                        bit_counter <= bit_counter - 1;
                        if (bit_counter == 0) begin
                            i2c_state <= I2C_WRITE_DATA;
                            i2c_data <= 8'b0000_0011;  // 启用 DAC
                            bit_counter <= 4'd7;
                        end
                    end
                end
                
                I2C_WRITE_DATA: begin
                    scl <= ~scl;
                    if (scl) begin
                        sda_out <= i2c_data[bit_counter];  // 发送数据的每一位
                        bit_counter <= bit_counter - 1;
                        if (bit_counter == 0) begin
                            i2c_state <= I2C_STOP;
                        end
                    end
                end
                
                I2C_STOP: begin
                    scl <= 1;
                    sda_out <= 1;  // 停止条件（SDA 拉高）
                    i2c_state <= I2C_IDLE;
                end
            endcase
        end
    end

    // I2S 控制的状态机
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i2s_state <= I2S_IDLE;    // 复位时进入空闲状态
            bclk <= 0;                // BCLK 设置为低电平（空闲状态）
            lrclk <= 0;               // LRCLK 初始化为低电平
            data <= 0;                // I2S 数据初始化为低电平
            i2s_bit_counter <= 6'd0;  // 复位位计数器
        end else begin
            case (i2s_state)
                I2S_IDLE: begin
                    if (start_audio) begin
                        audio_data <= audio_buffer[audio_index];  // 读取音频数据
                        i2s_bit_counter <= 6'd31;
                        i2s_state <= I2S_START;
                    end
                end
                
                I2S_START: begin
                    bclk <= 0;       // 准备发送第一个位
                    data <= audio_data[i2s_bit_counter];  // 发送第一个数据位
                    i2s_state <= I2S_TRANSFER;
                end
                
                I2S_TRANSFER: begin
                    bclk <= ~bclk;   // 翻转比特时钟信号
                    if (bclk) begin
                        i2s_bit_counter <= i2s_bit_counter - 1;
                        if (i2s_bit_counter == 0) begin
                            i2s_state <= I2S_IDLE;
                        end else begin
                            data <= audio_data[i2s_bit_counter - 1];  // 发送下一个数据位
                        end
                    end
                end
            endcase
        end
    end

    // SPI 接收音频数据的逻辑
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            audio_index <= 8'd0; // 复位音频数据索引
            spi_data_valid <= 0;
        end else if (spi_data_valid) begin
            // 将 SPI 接收的数据存入缓冲区
            audio_buffer[audio_index] <= spi_received_data;
            if (audio_index == 8'd255) begin
                audio_index <= 8'd0; // 循环使用缓冲区
            end else begin
                audio_index <= audio_index + 1;
            end
            spi_data_valid <= 0;
        end
    end

endmodule