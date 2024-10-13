module i2s_adc_controller(
    input wire clk,               // FPGA主时钟
    input wire reset,             // 复低信号
    input wire [31:0] audio_data, // 输入音频数据（32位）
    output wire i2s_sck,          // I2S串行时钟 (BCLK)
    output wire i2s_ws,           // I2S字选择 (LRCLK)
    output wire i2s_sd            // I2S串行数据线
);

    reg [31:0] data_reg;          // 32位数据存储器
    reg [5:0] bit_cnt;            // 计数器
    reg ws_reg, sck_reg, sd_reg;
    reg load_new_data;            // 标志是否需要加载新数据

    assign i2s_sck = sck_reg;
    assign i2s_ws = ws_reg;
    assign i2s_sd = sd_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            sck_reg <= 0;
            ws_reg <= 0; 
            sd_reg <= 0;
            bit_cnt <= 0;
            load_new_data <= 1;
        end else begin
            // 时钟生成逻辑：sck_reg在每个时钟周期翻转
            sck_reg <= ~sck_reg;

            if (sck_reg == 1) begin  // 在SCK上升沿更新数据
                if (bit_cnt == 63) begin
                    // 完成左右声道的32位数据传输，切换声道
                    ws_reg <= ~ws_reg;
                    bit_cnt <= 0;
                    load_new_data <= 1;  // 标志需要加载新数据
                end else begin
                    bit_cnt <= bit_cnt + 1;
                    sd_reg <= data_reg[31];  // 从高位开始传输
                    data_reg <= data_reg << 1;  // 左移，准备传输下一个位
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