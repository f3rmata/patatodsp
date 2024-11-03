`timescale 1ns / 1ps
module es9821q_controller_tb_2;
    // Inputs
    reg sys_clk;
    reg rst_n;
    reg i2c_start;

    // Bidirectional
    reg sda_reg;         // 用于控制 SDA 的 reg 类型信号
    wire sda;

    // Outputs
    wire i2c_done;
    wire i2c_ack;
    wire scl;
    wire i2c_drive_clk;

    // Assign SDA to emulate bidirectional behavior with pull-up
    assign sda = (sda_reg == 1'b0) ? 1'b0 : 1'bz;

    // Instantiate the Unit Under Test (UUT)
    clkk #(
        .SYS_CLK_FREQ('d50_000_000),
        .I2C_CLK('d100_000),
        .SLAVE_ADDR(7'h40)
    ) uut (
        .sys_clk(sys_clk),
        .rst_n(rst_n),
        .i2c_start(i2c_start),
        .i2c_done(i2c_done),
        .i2c_ack(i2c_ack),
        .scl(scl),
        .sda(sda),
        .i2c_drive_clk(i2c_drive_clk)
    );

    // Clock generation
    always #10 sys_clk = ~sys_clk; // 50 MHz clock

    // Test stimulus
    initial begin
        // Initialize Inputs
        rst_n = 0;
        i2c_start = 0;
        sda_reg = 1;  // 初始时 SDA 拉高，模拟上拉

        // Wait for global reset
        #100;
        rst_n = 1;

        // Start I2C transaction
        #1000;
        i2c_start = 1;

        // Wait for I2C transaction to complete
        wait(i2c_done == 1);
        #50;

        #10000
        // Finish simulation
        $dumpfile("file.vcd");
        $dumpvars(0, es9821q_controller_tb_2);
        $finish;
    end

    // SDA behavior simulation
    always @(negedge scl or negedge rst_n) begin
        if (!rst_n) begin
            sda_reg <= 1; // 复位时，SDA 默认上拉
        end else begin
            // 模拟从机应答：在发送从机地址时拉低 SDA 以进行应答
            if (uut.cur_state == uut.Write_slave_addr_state && uut.clk4_cnt == 'd37) begin
                sda_reg <= 0; // 模拟从机应答
            end else begin
                sda_reg <= 1; // 默认情况下 SDA 上拉
            end
        end
    end
endmodule
