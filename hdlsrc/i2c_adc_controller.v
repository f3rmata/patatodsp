module i2c_adc_controller(
    input wire clk,           // FPGA主时钟（50 MHz）
    input wire reset,         // 复位信号
    input wire start,         // 启动I2C传输信号，高电平有效
    input wire [6:0] addr,    // 7位I2C设备地址
    input wire [7:0] reg_addr, // 8位寄存器地址
    input wire [7:0] data,    // 8位数据值
    output reg scl,           // I2C时钟线
    inout wire sda,           // I2C数据线
    output reg busy,          // I2C忙信号，用于指示I2C传输正在进行
    output reg ack_error      // 应答错误信号，表示未收到从设备的应答
);

    // 状态机定义
    reg [4:0] state;
    parameter IDLE = 5'b00000, START = 5'b00001, ADDR = 5'b00010, REG_ADDR = 5'b00011,
              DATA = 5'b00100, ACK_CHECK = 5'b00101, STOP = 5'b00110, INIT_REG1 = 5'b00111, INIT_REG2 = 5'b01000, SET_SLAVE_MODE = 5'b01001,
              SET_ADC_CLK_DIV2 = 5'b01010, SET_SELECT_ADC_NUM = 5'b01011, SET_SELECT_IADC_NUM = 5'b01100, ENABLE_ADC = 5'b01101;

    reg sda_reg;             // SDA数据寄存器，用于控制SDA的输出值
    reg sda_dir;             // SDA方向控制信号，1表示输出，0表示输入
    reg [2:0] bit_cnt;       // 位计数器，用于逐位发送或接收数据

    // 统一声明寄存器变量，避免在状态机中声明
    reg [7:0] init_data1;    // 初始化寄存器1的数据
    reg [7:0] init_data2;    // 初始化寄存器2的数据
    reg [7:0] slave_mode_data; // 设置从模式的数据

    assign sda = (sda_dir) ? sda_reg : 1'bz;  // 当sda_dir为1时，驱动sda输出，否则保持高阻态

    // 分频器计数器，用于将50MHz时钟分频至100kHz，用于I2C时钟生成
    reg [8:0] clk_div_cnt;  // 9位计数器，支持0到499的计数范围
    reg clk_en;             // 用于使能I2C时钟的信号，每次达到计数器上限时拉高

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            clk_div_cnt <= 0;
            clk_en <= 0;
        end else if (clk_div_cnt == 249) begin
            clk_div_cnt <= 0;
            clk_en <= 1;  // 每250个时钟周期使能一次I2C逻辑，相当于将50MHz分频到100kHz
        end else begin
            clk_div_cnt <= clk_div_cnt + 1;
            clk_en <= 0;
        end
    end

    // 状态机逻辑
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // 重置所有状态和信号
            state <= IDLE;
            scl <= 1;            // 初始时SCL为高电平
            sda_reg <= 1;        // 初始时SDA为高电平
            sda_dir <= 1;        // 初始设置SDA为输出
            busy <= 0;           // 空闲状态
            ack_error <= 0;      // 清除应答错误状态
            bit_cnt <= 0;        // 位计数器清零
            init_data1 <= 8'h00; // 初始化寄存器1的数据
            init_data2 <= 8'h11; // 初始化寄存器2的数据
            slave_mode_data <= 8'h00; // 设置从模式的数据
        end else if (clk_en) begin  // 只有在分频后的I2C时钟使能时才更新状态
            case (state)
                IDLE: begin
                    // 等待启动信号
                    if (start) begin
                        busy <= 1;        // 标志I2C总线忙
                        ack_error <= 0;   // 清除之前的错误状态
                        sda_reg <= 1;     // 初始状态为高
                        scl <= 1;         // 保持SCL为高电平
                        state <= START;   // 进入START状态
                    end
                end
                START: begin
                    // 发送起始信号，SDA从高变为低，SCL保持高电平
                    sda_reg <= 0;
                    sda_dir <= 1;  // 设置为输出
                    scl <= 1;
                    state <= ADDR; // 准备发送设备地址
                end
                ADDR: begin
                    // 逐位发送设备地址和写信号（R/W位=0表示写操作）
                    if (bit_cnt < 7) begin
                        scl <= 0;  // 拉低SCL，准备发送数据位
                        sda_reg <= addr[6 - bit_cnt];  // 从最高位开始发送地址
                        bit_cnt <= bit_cnt + 1;
                        scl <= 1;  // 拉高SCL，完成数据位传输
                    end else begin
                        // 发送写信号（R/W位 = 0）
                        scl <= 0;
                        sda_reg <= 0;  // 写操作
                        scl <= 1;
                        bit_cnt <= 0;  // 重置位计数器
                        state <= ACK_CHECK;  // 进入应答检测状态
                    end
                end
                ACK_CHECK: begin
                    // 检测应答信号
                    scl <= 1;      // 拉高SCL，准备读取应答信号
                    sda_dir <= 0;  // 设置为输入，等待从设备的ACK信号
                    if (sda == 0) begin
                        // 收到应答信号，表示从设备已正确接收数据
                        scl <= 0;
                        sda_dir <= 1;  // 设置为输出，准备发送下一个字节
                        case (state)
                            ADDR: state <= REG_ADDR;         // 地址发送完成，进入寄存器地址发送状态
                            REG_ADDR: state <= INIT_REG1;    // 寄存器地址发送完成，进入初始化寄存器1状态
                            INIT_REG1: state <= INIT_REG2;   // 初始化寄存器1完成，进入初始化寄存器2状态
                            INIT_REG2: state <= SET_SLAVE_MODE; // 初始化寄存器2完成，进入设置从模式状态
                            SET_SLAVE_MODE: state <= SET_ADC_CLK_DIV2; // 设置从模式完成，进入设置ADC时钟状态
                            SET_ADC_CLK_DIV2: state <= SET_SELECT_ADC_NUM; // 设置ADC时钟完成，进入设置ADC分频状态
                            SET_SELECT_ADC_NUM: state <= SET_SELECT_IADC_NUM; // 设置ADC分频完成，进入设置IADC分频状态
                            SET_SELECT_IADC_NUM: state <= ENABLE_ADC; // 设置IADC分频完成，进入启用ADC状态
                            ENABLE_ADC: state <= STOP;       // 启用ADC完成，进入停止状态
                            default: state <= STOP;          // 其他情况直接进入停止状态
                        endcase
                    end else begin
                        // 未收到应答信号，发生错误
                        ack_error <= 1;  // 标记应答错误
                        state <= STOP;   // 进入停止状态
                    end
                end
                REG_ADDR: begin
                    // 逐位发送寄存器地址
                    if (bit_cnt < 8) begin
                        scl <= 0;  // 拉低SCL，准备发送寄存器地址位
                        sda_reg <= reg_addr[7 - bit_cnt];  // 从最高位开始发送寄存器地址
                        bit_cnt <= bit_cnt + 1;
                        scl <= 1;  // 拉高SCL，完成数据位传输
                    end else begin
                        bit_cnt <= 0;  // 重置位计数器
                        state <= DATA; // 进入数据发送状态
                    end
                end
                DATA: begin
                    // 逐位发送用于设置从模式的数据
                    if (bit_cnt < 8) begin
                        scl <= 0;  // 拉低SCL，准备发送数据位
                        sda_reg <= data[7 - bit_cnt];  // 发送数据，从最高位开始
                        bit_cnt <= bit_cnt + 1;
                        scl <= 1;  // 拉高SCL，完成数据位传输
                    end else begin
                        bit_cnt <= 0;  // 重置位计数器
                        state <= ACK_CHECK; // 进入应答检测状态
                    end
                end
                INIT_REG1: begin
                    // 逐位初始化寄存器1的数据 (0x29[1:0] = 2'b00)
                    if (bit_cnt < 8) begin
                        scl <= 0;  // 拉低SCL，准备发送数据位
                        sda_reg <= init_data1[7 - bit_cnt];  // 发送数据
                        bit_cnt <= bit_cnt + 1;
                        scl <= 1;  // 拉高SCL，完成数据位传输
                    end else begin
                        bit_cnt <= 0;  // 重置位计数器
                        state <= ACK_CHECK; // 进入应答检测状态
                    end
                end
                INIT_REG2: begin
                    // 逐位初始化寄存器2的数据 (0x26[7:0] = 8'h11)
                    if (bit_cnt < 8) begin
                        scl <= 0;  // 拉低SCL，准备发送数据位
                        sda_reg <= init_data2[7 - bit_cnt];  // 发送数据
                        bit_cnt <= bit_cnt + 1;
                        scl <= 1;  // 拉高SCL，完成数据位传输
                    end else begin
                        bit_cnt <= 0;  // 重置位计数器
                        state <= ACK_CHECK; // 进入应答检测状态
                    end
                end
                SET_SLAVE_MODE: begin
                    // 设置为从模式 (0x04[7:0] = 8'h00)
                    if (bit_cnt < 8) begin
                        scl <= 0;  // 拉低SCL，准备发送数据位
                        sda_reg <= slave_mode_data[7 - bit_cnt];  // 发送数据
                        bit_cnt <= bit_cnt + 1;
                        scl <= 1;  // 拉高SCL，完成数据位传输
                    end else begin
                        bit_cnt <= 0;  // 重置位计数器
                        state <= ACK_CHECK; // 进入应答检测状态
                    end
                end
                SET_ADC_CLK_DIV2: begin
                    // 设置ADC时钟为全速率
                    state <= REG_ADDR; // 进入寄存器地址发送状态
                end
                SET_SELECT_ADC_NUM: begin
                    // 设置SELECT_ADC_NUM为最小值
                    state <= REG_ADDR; // 进入寄存器地址发送状态
                end
                SET_SELECT_IADC_NUM: begin
                    // 设置SELECT_IADC_NUM为最小值
                    state <= REG_ADDR; // 进入寄存器地址发送状态
                end
                ENABLE_ADC: begin
                    // 启用ADC (0x00[1] = 1)
                    state <= REG_ADDR; // 进入寄存器地址发送状态
                end
                STOP: begin
                    // 发送停止信号
                    scl <= 1;
                    sda_reg <= 1;  // 停止条件：SCL高电平时，SDA上升到高电平
                    sda_dir <= 1;
                    state <= IDLE;
                    busy <= 0;  // 标志I2C总线空闲
                end
            endcase
        end
    end
endmodule