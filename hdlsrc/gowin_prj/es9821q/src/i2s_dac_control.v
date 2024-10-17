// 修改 i2s_dac_control 模块的接口
module i2s_dac_control (
    input wire clk,               // 系统时钟
    input wire rst_n,             // 低电平复位
    output reg bclk,              // I2S 比特时钟
    output reg lrclk,             // I2S 左右声道时钟
    input wire [31:0] data        // 修改为输入，I2S 数据线
);

    // I2S 参数
    localparam I2S_IDLE      = 2'd0;   // I2S 空闲状态
    localparam I2S_START     = 2'd1;   // I2S 起始状态
    localparam I2S_TRANSFER  = 2'd2;   // I2S 传输状态
    reg [1:0] i2s_state;          // 当前 I2S 状态机的状态
    reg [5:0] i2s_bit_counter;    // I2S 位计数器
    reg data_out;                 // I2S 数据输出寄存器

    // 用于生成 bclk 的分频计数器
    reg [3:0] clk_div;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            clk_div <= 4'd0;
            bclk <= 0;
        end else begin
            if (clk_div == 4'd15) begin
                clk_div <= 4'd0;
                bclk <= ~bclk;  // 每 16 个时钟周期翻转一次 bclk
            end else begin
                clk_div <= clk_div + 1;
            end
        end
    end

    // 用于生成 lrclk 的计数器
    reg [5:0] lrclk_counter;
    always @(posedge bclk or negedge rst_n) begin
        if (!rst_n) begin
            lrclk_counter <= 6'd0;
            lrclk <= 0;
        end else begin
            if (lrclk_counter == 6'd31) begin
                lrclk_counter <= 6'd0;
                lrclk <= ~lrclk;  // 每 32 个 bclk 周期翻转一次 lrclk
            end else begin
                lrclk_counter <= lrclk_counter + 1;
            end
        end
    end

    // I2S 控制的状态机
    always @(posedge bclk or negedge rst_n) begin
        if (!rst_n) begin
            i2s_state <= I2S_IDLE;    // 复位时进入空闲状态
            i2s_bit_counter <= 6'd0;  // 复位位计数器
            data_out <= 0;            // 数据输出复位
        end else begin
            case (i2s_state)
                I2S_IDLE: begin
                    i2s_bit_counter <= 6'd31;
                    i2s_state <= I2S_START;
                end
                
                I2S_START: begin
                    data_out <= data[i2s_bit_counter]; // 发送第一个数据位
                    i2s_state <= I2S_TRANSFER;
                end
                
                I2S_TRANSFER: begin
                    if (i2s_bit_counter == 0) begin
                        i2s_state <= I2S_IDLE;
                    end else begin
                        i2s_bit_counter <= i2s_bit_counter - 1;
                        data_out <= data[i2s_bit_counter]; // 发送下一个数据位
                    end
                end
            endcase
        end
    end

endmodule
