module i2s_dac_control (
    input wire clk,               // 系统时钟
    input wire rst_n,             // 低电平复位
    output reg bclk,              // I2S 比特时钟
    output reg lrclk,             // I2S 左右声道时钟
    output reg data,              // I2S 数据线
    input wire start_audio       // 启动 I2S 音频传输的信号
);

    // I2S 参数
    localparam I2S_IDLE      = 2'd0;   // I2S 空闲状态
    localparam I2S_START     = 2'd1;   // I2S 起始状态
    localparam I2S_TRANSFER  = 2'd2;   // I2S 传输状态
    reg [31:0] audio_buffer [0:255];  // 音频数据缓冲区
    reg [1:0] i2s_state;          // 当前 I2S 状态机的状态
    reg [31:0] audio_data;        // 通过 I2S 发送的音频数据（32 位）
    reg [5:0] i2s_bit_counter;    // I2S 位计数器
    reg [7:0] audio_index;        // 当前音频数据索引

    // I2S 控制的状态机
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i2s_state <= I2S_IDLE;    // 复位时进入空闲状态
            bclk <= 0;                // BCLK 设置为低电平（空闲状态）
            lrclk <= 0;               // LRCLK 初始化为低电平
            data <= 0;                // I2S 数据初始化为低电平
            i2s_bit_counter <= 6'd0;  // 复位位计数器
            audio_index <= 8'd0;      // 复位音频数据索引
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
                            audio_index <= audio_index + 1;
                            if (audio_index == 8'd255) begin
                                audio_index <= 8'd0; // 循环播放音频数据
                            end
                            i2s_state <= I2S_IDLE;
                        end else begin
                            data <= audio_data[i2s_bit_counter - 1];  // 发送下一个数据位
                        end
                    end
                end
            endcase
        end
    end

endmodule