module i2c_adc_controller(
    input wire clk,           // FPGA主时钟（50 MHz）
    input wire reset,         // 复位信号
    input wire start,         // 启动I2C传输信号，高电平有效
    input wire [6:0] addr,    // 7位I2C设备地址
    input wire [7:0] reg_addr, // 8位存储器地址
    input wire [7:0] data,    // 8位数据值
    output reg scl,           // I2C时钟线
    inout wire sda,           // I2C数据线
    output reg busy,          // I2C忙信号，用于指示I2C传输正在进行
    output reg ack_error      // 应答错误信号，表示未收到从设备的应答
);

    // 状态机定义
    reg [4:0] state;
    parameter IDLE = 5'b00000, START = 5'b00001, ADDR = 5'b00010, REG_ADDR = 5'b00011,
              DATA = 5'b00100, ACK_CHECK = 5'b00101, STOP = 5'b00110, WAIT_DELAY = 5'b00111,
              INIT_REG1 = 5'b01000, INIT_REG2 = 5'b01001,INIT_REG3 = 5'b01010, SET_SLAVE_MODE = 5'b01011,
              SET_ADC_CLK_DIV2 = 5'b01100, SET_SELECT_ADC_NUM = 5'b01101, SET_SELECT_IADC_NUM = 5'b01110, ENABLE_ADC = 5'b01111;

    reg sda_reg;             // SDA数据存储器，用于控制SDA的输出值
    reg sda_dir;             // SDA方向控制信号，1表示输出，0表示输入
    reg [3:0] bit_cnt;       // 位计数器，用于逐位发送或接收数据

    reg [7:0] reg_addr_reg;  // 存储当前存储器地址的存储器变量
    reg [7:0] data_reg;      // 存储当前发送的数据

    reg [3:0] delay_cnt;     // 延时计数器
    reg delay_done;          // 延时完成信号

    assign sda = (sda_dir) ? sda_reg : 1'bz;  // 当sda_dir为1时，驱动sda输出，否则保持高阻态

    // 分频器计数器，用于将50MHz时钟分频至100kHz，用于I2C时钟生成
    reg [8:0] clk_div_cnt;  // 9位计数器，支持0到499的计数范围
    reg clk_en;             // 用于使能I2C时钟的信号，每次达到计数器上限时拉高

    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            clk_div_cnt <= 0;
            clk_en <= 0;
        end else if (clk_div_cnt == 499) begin
            clk_div_cnt <= 0;
            clk_en <= 1;  // 每500个时钟周期使能一次I2C逻辑，相当于将50MHz分频到100kHz
        end else begin
            clk_div_cnt <= clk_div_cnt + 1;
            clk_en <= 0;
        end
    end

    // 延时计数器逻辑
    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            delay_cnt <= 0;
            delay_done <= 0;
        end else if (state == WAIT_DELAY) begin
            if (delay_cnt == 15) begin
                delay_done <= 1;
                delay_cnt <= 0;
            end else begin
                delay_cnt <= delay_cnt + 1;
                delay_done <= 0;
            end
        end else begin
            delay_cnt <= 0;
            delay_done <= 0;
        end
    end

    // 状态机逻辑
    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            // 重置所有状态和信号
            state <= IDLE;
            scl <= 1;            // 初始时SCL为高电平
            sda_reg <= 1;        // 初始时SDA为高电平
            sda_dir <= 1;        // 初始设置SDA为输出
            busy <= 0;           // 空闲状态
            ack_error <= 0;      // 清除应答错误状态
            bit_cnt <= 0;        // 位计数器清零
            reg_addr_reg <= 8'h00; // 存储器地址初始化
            data_reg <= 8'h00;   // 数据初始化
        end else if (clk_en) begin  // 只有在分频后的I2C时钟使能时才更新状态
            case (state)
                IDLE: begin
                    // 等待启动信号
                    if (start) begin
                        busy <= 1;        // 标志I2C总线忙
                        ack_error <= 0;   // 清除之前的错误状态
                        sda_reg <= 1;     // 初始状态为高
                        scl <= 1;         // 保持SCL为高电平
                        reg_addr_reg <= reg_addr; // 存储存储器地址
                        data_reg <= data; // 存储要发送的数据
                        state <= INIT_REG1;   // 进入初始化寄存器1状态
                    end
                end
                INIT_REG1: begin
                    // 初始化寄存器1的逻辑
                    reg_addr_reg <= 8'h1D; // 寄存器地址 0x1D
                    data_reg <= 8'h00;     // 设置 GPIO1 和 GPIO2 为三态
                    state <= WAIT_DELAY;     // 延时之后发送起始信号状态
                end
                INIT_REG2: begin
                    // 初始化寄存器2的逻辑
                    reg_addr_reg <= 8'h1A; // 寄存器地址 0x1A
                    data_reg <= 8'h11;     // 设置 GPIO1 和 GPIO2 为辅助输入
                    state <= WAIT_DELAY;     // 延时之后发送起始信号状态
                end
                 INIT_REG3: begin
                    // 初始化寄存器3的逻辑
                    reg_addr_reg <= 8'h03; // 寄存器地址 0x03
                    data_reg <= 8'b00000000;     // 不分频
                    state <= WAIT_DELAY;     // 延时之后发送起始信号状态
                end
                SET_SLAVE_MODE: begin
                    // 设置设备为从模式的逻辑
                    reg_addr_reg <= 8'h04; // 寄存器地址 0x04
                    data_reg <= 8'b10000010;     // 设置为从模式并且直接使用主编码时钟（不使用外部晶振）
                    state <= WAIT_DELAY;     // 延时之后发送起始信号状态
                end
                SET_ADC_CLK_DIV2: begin
                    // 设置 ADC 时钟分频为二分之一速率的逻辑
                    reg_addr_reg <= 8'h02; // 寄存器地址 0x02
                    data_reg <= 8'h01;     // 设置 ADC 时钟分频为二分之一
                    state <= WAIT_DELAY;     // 延时之后发送起始信号状态
                end
                SET_SELECT_ADC_NUM: begin
                    // 设置 SELECT_ADC_NUM，配置 ADC 的时钟分频系数
                    reg_addr_reg <= 8'h01; // 寄存器地址 0x01
                    data_reg <= 8'h00;     // 配置 ADC 的时钟分频系数为 1
                    state <= WAIT_DELAY;     // 延时之后发送起始信号状态
                end
                SET_SELECT_IADC_NUM: begin
                    // 设置 SELECT_IADC_NUM，配置内部 ADC 的时钟分频值
                    reg_addr_reg <= 8'h02; // 寄存器地址 0x02
                    data_reg <= 8'h03;     // 配置内部 ADC 的时钟分频值
                    state <= WAIT_DELAY;     // 延时之后发送起始信号状态
                end
                ENABLE_ADC: begin
                    // 启用 ADC 的逻辑
                    reg_addr_reg <= 8'h00; // 寄存器地址 0x00
                    data_reg <= 8'h10;     // 启用 ADC 并设置 ENABLE_2X_MODE
                    state <= WAIT_DELAY;     // 延时之后发送起始信号状态
                end
                START: begin
                    // 发送起始信号，SDA从高变为低，SCL保持高电平
                    scl <= 1;     // 确保SCL为高电平
                    sda_reg <= 0; // 将SDA拉低以产生起始信号
                    sda_dir <= 1;  // 设置为输出
                    state <= ADDR;  // 进入发送设备地址状态
                end
                WAIT_DELAY: begin
                    // 等待延时完成
                    if (delay_done) begin
                        // 延时完成后跳转到下一个状态
                        if (state == INIT_REG1) state <= INIT_REG2;
                        else if (state == INIT_REG2) state <= INIT_REG3;
                        else if (state == INIT_REG3) state <= SET_SLAVE_MODE;
                        else if (state == SET_SLAVE_MODE) state <= SET_ADC_CLK_DIV2;
                        else if (state == SET_ADC_CLK_DIV2) state <= SET_SELECT_ADC_NUM;
                        else if (state == SET_SELECT_ADC_NUM) state <= SET_SELECT_IADC_NUM;
                        else if (state == SET_SELECT_IADC_NUM) state <= ENABLE_ADC;
                        else if (state == ENABLE_ADC) state <= START;
                        else state <= ADDR;
                    end
                end
                ADDR: begin
                    // 逐位发送设备地址和写信号（R/W位=0表示写操作）
                    if (bit_cnt < 7) begin
                        sda_dir <= 1;  // 设置为输出模式
                        sda_reg <= addr[6 - bit_cnt];  // 从最高位开始发送地址
                        scl <= 0;  // 拉低SCL，准备发送数据位
                        bit_cnt <= bit_cnt + 1;
                        state <= WAIT_DELAY;  // 进入延时状态
                    end else begin
                        // 发送写信号（R/W位 = 0）
                        sda_reg <= 0;
                        scl <= 0;
                        sda_dir <= 0;  // 设置为输入，等待从设备的ACK信号
                        bit_cnt <= 0;  // 重置位计数器
                        state <= WAIT_DELAY;  // 进入延时状态
                    end
                end
                ACK_CHECK: begin
                    // 检测应答信号
                    sda_dir <= 0;  // 设置为输入模式
                    scl <= 1;      // 拉高SCL，准备读取应答信号
                    if (delay_done) begin
                        if (sda == 0) begin
                            // 收到应答信号，进入下一个状态
                            if (state == ADDR) begin
                                state <= REG_ADDR;
                            end else if (state == REG_ADDR) begin
                                state <= DATA;
                            end else if (state == DATA) begin
                                state <= STOP;
                            end
                        end else begin
                            // 未收到应答，进入停止状态
                            ack_error <= 1;
                            state <= STOP;
                        end
                    end else begin
                        state <= WAIT_DELAY;  // 延时未完成，保持在延时状态
                    end
                end
                REG_ADDR: begin
                    // 逐位发送存储器地址
                    if (bit_cnt < 8) begin
                        sda_dir <= 1;  // 设置为输出模式
                        sda_reg <= reg_addr_reg[7 - bit_cnt];  // 从最高位开始发送存储器地址
                        scl <= 0;  // 拉低SCL，准备发送数据位
                        bit_cnt <= bit_cnt + 1;
                        state <= WAIT_DELAY;  // 进入延时状态
                    end else begin
                        bit_cnt <= 0;  // 重置位计数器
                        sda_dir <= 0;  // 设置为输入，准备发送ACK
                        state <= WAIT_DELAY;  // 进入延时状态
                    end
                end
                DATA: begin
                    // 逐位发送数据
                    if (bit_cnt < 8) begin
                        sda_dir <= 1;  // 设置为输出模式
                        sda_reg <= data_reg[7 - bit_cnt];  // 发送数据，从最高位开始
                        scl <= 0;  // 拉低SCL，准备发送数据位
                        bit_cnt <= bit_cnt + 1;
                        state <= WAIT_DELAY;  // 进入延时状态
                    end else begin
                        bit_cnt <= 0;  // 重置位计数器
                        sda_dir <= 0;  // 设置为输入，准备发送ACK
                        state <= WAIT_DELAY;  // 进入延时状态
                    end
                end
                STOP: begin
                    // 发送停止信号
                    scl <= 1;
                    sda_reg <= 1;  // 停止条件：SCL高电平时，SDA上升到高电平
                    sda_dir <= 1;
                    state <= WAIT_DELAY;  // 进入延时状态，确保停止条件维持
                end
            endcase
       end
    end
endmodule