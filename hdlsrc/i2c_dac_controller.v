module i2c_dac_control (
    input wire clk,               // 系统时钟
    input wire rst_n,             // 低电平复位
    inout wire sda,               // I2C 数据线
    output reg scl,               // I2C 时钟线
    input wire start_config,      // 启动 I2C 配置的信号
    input wire [6:0] i2c_addr,    // I2C 地址
    input wire [7:0] reg_addr,    // 寄存器地址
    input wire [7:0] data         // 要发送的数据
);

    // I2C 参数
    localparam I2C_IDLE       = 3'd0;  // I2C 空闲状态
    localparam I2C_START      = 3'd1;  // I2C 起始条件状态
    localparam I2C_ADDR       = 3'd2;  // I2C 发送地址状态
    localparam I2C_WRITE_REG  = 3'd3;  // I2C 发送寄存器地址状态
    localparam I2C_WRITE_DATA = 3'd4;  // I2C 发送数据状态
    localparam I2C_ACK        = 3'd5;  // I2C ACK 状态
    localparam I2C_STOP       = 3'd6;  // I2C 停止条件状态

    reg [2:0] i2c_state;          // 当前 I2C 状态机的状态
    reg [7:0] i2c_data;           // 通过 I2C 发送的数据
    reg [3:0] bit_counter;        // 位计数器，用于跟踪正在传输的位数

    // 时钟分频
    reg [15:0] clk_div;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            clk_div <= 16'd0;
        else
            clk_div <= clk_div + 1;
    end

    wire scl_enable = (clk_div == 16'd0); // 分频时钟使能信号

    // SDA 输出逻辑
    reg sda_out;
    reg sda_oe;  // SDA 输出使能
    assign sda = (sda_oe) ? sda_out : 1'bz;

    // I2C 控制的状态机
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i2c_state <= I2C_IDLE;    // 复位时进入空闲状态
            scl <= 1;                 // SCL 设置为高电平（空闲状态）
            sda_out <= 1;             // SDA 设置为高电平（空闲状态）
            sda_oe <= 0;              // SDA 输出禁用
            bit_counter <= 4'd0;      // 复位位计数器
        end else if (scl_enable) begin
            case (i2c_state)
                I2C_IDLE: begin
                    if (start_config) begin
                        i2c_state <= I2C_START;
                        sda_out <= 0;  // 起始条件（SDA 拉低）
                        sda_oe <= 1;
                    end
                end

                I2C_START: begin
                    scl <= 0;            // 拉低 SCL 准备发送
                    i2c_data <= {i2c_addr, 1'b0};  // 地址 + 写位
                    bit_counter <= 4'd7;
                    i2c_state <= I2C_ADDR;
                end

                I2C_ADDR: begin
                    scl <= ~scl;         // 翻转 SCL
                    if (scl) begin       // 在 SCL 低电平时设置数据
                        sda_out <= i2c_data[bit_counter];
                        bit_counter <= bit_counter - 1;
                        if (bit_counter == 0)
                            i2c_state <= I2C_ACK;
                    end
                end

                I2C_ACK: begin
                    scl <= ~scl;
                    if (!scl) begin
                        sda_oe <= 0;  // SDA 设为输入模式以读取 ACK
                    end else begin
                        if (sda == 0) begin  // 检查 ACK
                            i2c_state <= I2C_WRITE_REG;
                            sda_oe <= 1;
                            i2c_data <= reg_addr;  // 设置寄存器地址
                            bit_counter <= 4'd7;
                        end else begin
                            i2c_state <= I2C_STOP;  // 如果没有收到 ACK 则停止传输
                        end
                    end
                end

                I2C_WRITE_REG: begin
                    scl <= ~scl;
                    if (scl) begin
                        sda_out <= i2c_data[bit_counter];
                        bit_counter <= bit_counter - 1;
                        if (bit_counter == 0) begin
                            i2c_state <= I2C_ACK;
                            i2c_data <= data;  // 要写入的数据
                            bit_counter <= 4'd7;
                        end
                    end
                end

                I2C_WRITE_DATA: begin
                    scl <= ~scl;
                    if (scl) begin
                        sda_out <= i2c_data[bit_counter];
                        bit_counter <= bit_counter - 1;
                        if (bit_counter == 0) begin
                            // 添加配置以启用 DAC 模式并选择通道 1
                            i2c_state <= I2C_WRITE_REG;
                            i2c_data <= 8'h47;  // GPIO_DAC_MODE 寄存器地址
                            bit_counter <= 4'd7;
                        end
                    end
                end

                I2C_WRITE_REG: begin
                    scl <= ~scl;
                    if (scl) begin
                        sda_out <= i2c_data[bit_counter];
                        bit_counter <= bit_counter - 1;
                        if (bit_counter == 0) begin
                            i2c_state <= I2C_ACK;
                            i2c_data <= 8'b0000_0010;  // 设置 GPIO_DAC_MODE 以选择通道 1 并启用 DAC 模式
                            bit_counter <= 4'd7;
                        end
                    end
                end

                I2C_STOP: begin
                    scl <= 1;
                    sda_out <= 1;  // 停止条件（SDA 拉高）
                    sda_oe <= 1;
                    i2c_state <= I2C_IDLE;
                end
            endcase
        end
    end

endmodule