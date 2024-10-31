module i2c_adc_controller(
    input wire clk,           // FPGA主时钟（50 MHz）
    input wire reset,         // 复位信号
    input wire start,         // 启动I2C传输信号，高电平有效
   // input wire [6:0] addr,    // 7位I2C设备地址
   // input wire [7:0] reg_addr, // 8位存储器地址
   // input wire [7:0] data,    // 8位数据值
    output reg scl,           // I2C时钟线
    inout wire sda,           // I2C数据线
    output reg busy,          // I2C忙信号，用于指示I2C传输正在进行
    output reg ack_error      // 应答错误信号，表示未收到从设备的应答
);

    // 状态机定义
    reg [4:0] state, next_state;
    parameter IDLE = 5'b00000, START = 5'b00001, ADDR = 5'b00010, SET_SCL_HIGH = 5'b00011,
              ACK_CHECK = 5'b00100, CHECK_ACK_RESULT = 5'b00101, REG_ADDR = 5'b00110, DATA = 5'b00111,
              CHECK_ACK_RESULT_DATA = 5'b01000, STOP = 5'b01001, WAIT_DELAY = 5'b01010,SET_SCL_HIGH_REG_ADDR = 5'b01011,SET_SCL_HIGH_DATA = 5'b01100;

    reg sda_reg;             // SDA数据存储器，用于控制SDA的输出值
    reg sda_dir;             // SDA方向控制信号，1表示输出，0表示输入
    reg [3:0] bit_cnt;       // 位计数器，用于逐位发送或接收数据

    reg [7:0] reg_addr_reg;  // 存储当前存储器地址的存储器变量
    reg [7:0] data_reg;      // 存储当前发送的数据

    reg [5:0] delay_cnt;     // 延时计数器
    reg [6:0] addr_reg;      // 存储I2C设备地址

    assign sda = (sda_dir) ? sda_reg : 1'bz;  // 当sda_dir为1时，驱动sda输出，否则保持高阻态

    // 分额器计数器，用于将50MHz时钟分额至100kHz，用于I2C时钟生成
    reg [8:0] clk_div_cnt;  // 9位计数器，支持0到499的计数范围
    reg clk_en;             // 用于使能I2C时钟的信号，每次达到计数器上限时拉高

    always @(posedge clk or negedge reset) begin
        if (!reset) begin
            clk_div_cnt <= 0;
            clk_en <= 0;
        end else if (clk_div_cnt == 499) begin
            clk_div_cnt <= 0;
            clk_en <= 1;  // 保持 clk_en 为高
        end else begin
            clk_div_cnt <= clk_div_cnt + 1;
            if (clk_en == 1) begin
                clk_en <= 0;  // 在下一周期将 clk_en 置为低
            end
        end
    end

    // 状态机逻辑
    reg [7:0] data_array [0:15]; // 数据数组，存储要依次发送的数据
    reg [7:0] reg_addr_array [0:15]; // 存储器地址数组，存储要依次发送的存储器地址
    integer data_index;

always @(posedge clk or negedge reset) begin
    if (!reset) begin
        // 重置所有状态和信号
        state <= IDLE;
        next_state <= IDLE;
        scl <= 1;            // 初始时SCL为高电平
        sda_reg <= 1;        // 初始时SDA为高电平
        sda_dir <= 1;        // 初始设置SDA为输出
        busy <= 0;           // 空闲状态
        ack_error <= 0;      // 清除应答错误状态
        bit_cnt <= 0;        // 位计数器清零
        reg_addr_reg <= 8'h00; // 存储器地址初始化
        data_reg <= 8'h00;   // 数据初始化
        delay_cnt <= 0;
        data_index <= 0;     // 初始化数据索引
        // 初始化数据数组和存储器地址数组
        data_array[0] <= 8'h00;
        data_array[1] <= 8'h11;
        data_array[2] <= 8'h00;
        data_array[3] <= 8'h82;
        data_array[4] <= 8'h00;
        data_array[5] <= 8'h03;
        data_array[6] <= 8'h02;
        data_array[7] <= 8'h02;
        data_array[8] <= 8'h00;
        data_array[9] <= 8'h02;

        reg_addr_array[0] <= 8'h1D;
        reg_addr_array[1] <= 8'h1A;
        reg_addr_array[2] <= 8'h03;
        reg_addr_array[3] <= 8'h04;
        reg_addr_array[4] <= 8'h01;
        reg_addr_array[5] <= 8'h02;
        reg_addr_array[6] <= 8'h00;
        reg_addr_array[7] <= 8'h02;
        reg_addr_array[8] <= 8'h00;
        reg_addr_array[9] <= 8'h02;

    end else if (clk_en) begin  // 只有在分频后的I2C时钟使能时才更新状态
        case (state)
            IDLE: begin
                // 等待启动信号
                if (start) begin
                    busy <= 1;        // 标志I2C总线忙
                    ack_error <= 0;   // 清除之前的错误状态
                    sda_reg <= 1;     // 初始状态为高
                    scl <= 1;         // 保持SCL为高电平
                    addr_reg <= 7'h40; // 将地址设为0x40，表示ADC设备的I2C地址
                    data_index <= 0;  // 重置数据索引
                    state <= START;   // 直接进入发送启动信号状态
                end
            end
            START: begin
                // 发送起始信号，SDA从高变为低，SCL保持高电平
                scl <= 1;     // 确保SCL为高电平
                sda_reg <= 0; // 将SDA拉低以产生起始信号
                sda_dir <= 1; // 设置为输出
                next_state <= ADDR;  // 保存下一个状态
                state <= WAIT_DELAY; // 进入延时状态，确保启动信号稳定
            end
            WAIT_DELAY: begin
                // 等待延时完成
                if (delay_cnt < 31) begin
                    delay_cnt <= delay_cnt + 1;
                end else begin
                    delay_cnt <= 0;
                    state <= next_state;  // 延时完成后跳转到保存的下一个状态
                end
            end
            ADDR: begin
                // 逐位发送设备地址和写信号（R/W位=0表示写操作）
                if (bit_cnt < 8) begin
                    sda_dir <= 1;  // 设置为输出模式
                    sda_reg <= (bit_cnt < 7) ? addr_reg[6 - bit_cnt] : 0;  // 发送地址的每一位，最后一位为写信号（0）
                    state <= WAIT_DELAY;  // 进入延时状态，确保SDA稳定
                    next_state <= SET_SCL_HIGH; // 下一个状态设置SCL为高
                end else begin
                    bit_cnt <= 0;  // 重置位计数器
                    sda_dir <= 0;  // 设置为输入，等待从设备的ACK信号
                    state <= WAIT_DELAY;  // 进入延时状态，准备检测ACK
                    next_state <= ACK_CHECK; // 保存下一个状态为ACK检测
                end
            end
            SET_SCL_HIGH: begin
                // 设置SCL为高电平，确保数据传输
                scl <= 1;
                state <= WAIT_DELAY;
                next_state <= ADDR; // 返回到地址发送逻辑，继续发送下一位
                bit_cnt <= bit_cnt + 1;
            end
            ACK_CHECK: begin
                // 检测应答信号
                sda_dir <= 0;  // 设置为输入模式
                scl <= 1;      // 拉高SCL，准备读取应答信号
                state <= WAIT_DELAY;
                next_state <= CHECK_ACK_RESULT;
            end
            CHECK_ACK_RESULT: begin
                // 检查ACK结果
                if (sda == 0) begin
                    // 收到应答信号，进入下一个状态
                    reg_addr_reg <= reg_addr_array[data_index]; // 更新要发送的存储器地址
                    state <= REG_ADDR;
                end else begin
                    // 未收到应答，进入停止状态
                    ack_error <= 1;
                    state <= STOP;
                end
            end
            REG_ADDR: begin
                // 逐位发送存储器地址
                if (bit_cnt < 8) begin
                    sda_dir <= 1;  // 设置为输出模式
                    sda_reg <= reg_addr_reg[7 - bit_cnt];  // 从最高位开始发送存储器地址
                    state <= WAIT_DELAY;  // 进入延时状态
                    next_state <= SET_SCL_HIGH_REG_ADDR; // 设置SCL为高
                end else begin
                    bit_cnt <= 0;  // 重置位计数器
                    sda_dir <= 0;  // 设置为输入，准备发送ACK
                    state <= WAIT_DELAY;  // 进入延时状态
                    next_state <= DATA; // 准备发送数据
                end
            end
            SET_SCL_HIGH_REG_ADDR: begin
                // 设置SCL为高电平，确保数据传输
                scl <= 1;
                state <= WAIT_DELAY;
                next_state <= REG_ADDR; // 返回到存储器地址发送逻辑，继续发送下一位
                bit_cnt <= bit_cnt + 1;
            end
            DATA: begin
                // 逐位发送数据
                if (bit_cnt < 8) begin
                    sda_dir <= 1;  // 设置为输出模式
                    sda_reg <= data_reg[7 - bit_cnt];  // 发送数据，从最高位开始
                    state <= WAIT_DELAY;  // 进入延时状态
                    next_state <= SET_SCL_HIGH_DATA; // 设置SCL为高
                end else begin
                    bit_cnt <= 0;  // 重置位计数器
                    sda_dir <= 0;  // 设置为输入，准备发送ACK
                    state <= WAIT_DELAY;  // 进入延时状态
                    next_state <= CHECK_ACK_RESULT_DATA; // 检查数据的ACK信号
                end
            end
            SET_SCL_HIGH_DATA: begin
                // 设置SCL为高电平，确保数据传输
                scl <= 1;
                state <= WAIT_DELAY;
                next_state <= DATA; // 返回到数据发送逻辑，继续发送下一位
                bit_cnt <= bit_cnt + 1;
            end
            CHECK_ACK_RESULT_DATA: begin
                // 检查数据发送后的ACK信号
                if (sda == 0) begin
                    // 收到ACK，准备发送下一个数据
                    if (data_index < 9) begin
                        data_index <= data_index + 1;
                        data_reg <= data_array[data_index]; // 更新要发送的数据
                        reg_addr_reg <= reg_addr_array[data_index]; // 更新要发送的存储器地址
                        state <= WAIT_DELAY;
                        next_state <= REG_ADDR;
                    end else begin
                        // 所有数据已发送完毕，进入停止状态
                        state <= STOP;
                    end
                end else begin
                    // 未收到ACK，进入停止状态
                    ack_error <= 1;
                    state <= STOP;
                end
            end
            STOP: begin
                // 发送停止信号
                scl <= 1;
                sda_reg <= 1;  // 停止条件：SCL高电平时，SDA上升到高电平
                sda_dir <= 1;
                state <= WAIT_DELAY;  // 进入延时状态，确保停止条件维持
                next_state <= IDLE;  // 保存下一个状态为IDLE
            end
        endcase
    end
end


endmodule
