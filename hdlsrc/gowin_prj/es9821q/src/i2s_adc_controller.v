module i2s_adc_controller(
    input wire clk,               // FPGA主时钟（50 MHz）
    input wire reset,             // 复位信号
    input wire [31:0] audio_data, // 输入音频数据（32位）
    output wire i2s_sck,          // I2S串行时钟 (BCLK)
    output wire i2s_ws,           // I2S字选择 (LRCLK)
    output wire i2s_sd            // I2S串行数据线
);

    reg [31:0] data_reg;          // 32位数据存储器
    reg [5:0] bit_cnt;            // 计数器
    reg ws_reg, sck_reg, sd_reg;
    reg load_new_data;            // 标志是否需要加载新数据

    reg [0:0] clk_div_cnt;        // 分频计数器，修改为1位以实现24.576MHz的BCLK

    assign i2s_sck = sck_reg;
    assign i2s_ws = ws_reg;
    assign i2s_sd = sd_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            clk_div_cnt <= 0;
            sck_reg <= 0;
            ws_reg <= 0; 
            sd_reg <= 0;
            bit_cnt <= 0;
            load_new_data <= 1;
        end else begin
            // 时钟分频逻辑：分频以生成 BCLK，DIV_FACTOR = 2 (生成24.576MHz的BCLK)
            if (clk_div_cnt == 1) begin
                clk_div_cnt <= 0;
                sck_reg <= ~sck_reg;  // 生成较高频率的 BCLK
            end else begin
                clk_div_cnt <= clk_div_cnt + 1;
            end

            // 在 SCK 下降沿更新数据
            if (sck_reg == 0) begin
                if (bit_cnt == 63) begin
                    // 完成左右声道的 32 位数据传输，切换声道
                    ws_reg <= ~ws_reg;
                    bit_cnt <= 0;
                    load_new_data <= 1;  // 标志需要加载新数据
                end else begin
                    bit_cnt <= bit_cnt + 1;
                    sd_reg <= data_reg[31];  // 从高位开始传输
                    data_reg <= {data_reg[30:0], 1'b0};  // 左移，准备传输下一个位
                end
            end

            // 加载新的音频数据
            if (load_new_data) begin
                data_reg <= audio_data;  // 加载新的音频数据
                load_new_data <= 0;
            end
        end
    end
endmodule
