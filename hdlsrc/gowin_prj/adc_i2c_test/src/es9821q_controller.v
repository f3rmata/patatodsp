module es9821q_controller
  (
    input wire  clk,   // 系统时钟
    input wire  rst_n, // 低电平复位
    output wire scl_adc,
    inout wire  sda_adc,
    output wire rrst
   );

    assign rrst = rst_n;

    wire busy_adc;
    wire ack_error_adc;

    reg [6:0] i2c_addr_adc = 7'h40; // ADC的I2C地址

    // 实例化I2C控制模块（用于ADC）
    i2c_adc_controller i2c_adc_inst
      (
       .sys_clk(clk),
       .rst_n(1'b1),             // 使用同步后的复位信号，低电平有效
       .i2c_start(1'b1),                 // 启动I2C传输的信号
       //.addr(i2c_addr_adc),      // ADC的I2C地址
       .scl(scl_adc),
       .sda(sda_adc)
       );

endmodule

