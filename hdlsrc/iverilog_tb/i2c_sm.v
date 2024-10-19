module i2c_sm (
               input wire clk,
               input wire reset
               );

   // 分频器计数器，用于将50MHz时钟分频至100kHz，用于I2C时钟生成
   reg [8:0]              clk_div_cnt;  // 9位计数器，支持0到499的计数范围
   reg                    clk_en;             // 用于使能I2C时钟的信号，每次达到计数器上限时拉高

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

   // 状态机定义
   reg [4:0] state;
   parameter IDLE = 5'b00000, START = 5'b00001, ADDR = 5'b00010, REG_ADDR = 5'b00011,
             DATA = 5'b00100, ACK_CHECK = 5'b00101, STOP = 5'b00110, WAIT_DELAY = 5'b00111,
             INIT_REG1 = 5'b01000, INIT_REG2 = 5'b01001,INIT_REG3 = 5'b01010, SET_SLAVE_MODE = 5'b01011,
             SET_ADC_CLK_DIV2 = 5'b01100, SET_SELECT_ADC_NUM = 5'b01101, SET_SELECT_IADC_NUM = 5'b01110, ENABLE_ADC = 5'b01111;

   reg       sda_reg;             // SDA数据存储器，用于控制SDA的输出值
   reg       sda_dir;             // SDA方向控制信号，1表示输出，0表示输入
   reg [3:0] bit_cnt;       // 位计数器，用于逐位发送或接收数据

   reg [7:0] reg_addr_reg;  // 存储当前存储器地址的存储器变量
   reg [7:0] data_reg;      // 存储当前发送的数据

   reg [3:0] delay_cnt;     // 延时计数器
   reg       delay_done;          // 延时完成信号

   assign sda = (sda_dir) ? sda_reg : 1'bz;  // 当sda_dir为1时，驱动sda输出，否则保持高阻态

endmodule // i2c_sm
