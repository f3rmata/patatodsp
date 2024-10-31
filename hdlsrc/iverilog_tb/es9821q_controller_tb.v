`timescale 1ns / 1ps

module es9821q_controller_tb;

    // Testbench signals
    reg clk;
    reg reset;
    reg start;
    reg [6:0] addr;
    reg [7:0] reg_addr;
    reg [7:0] data;
    wire scl;
    tri sda;
    wire busy;
    wire ack_error;

    // Instantiate the module under test (MUT)
    i2c_adc_controller uut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .scl(scl),
        .sda(sda),
        .busy(busy),
        .ack_error(ack_error)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        // Initialize testbench signals
        clk = 0;
        reset = 1;
        start = 0;
        addr = 7'b0010000;
        reg_addr = 8'h00;
        data = 8'h55;

        // Apply reset
        #20 reset = 0;
        #20 reset = 1;

        // Start I2C transaction
        #10000 start = 1;
        #10 start = 0;

        // Wait for a while to observe I2C signals
        #10000000;

        // Finish simulation
        $finish;
    end

    // Monitor SCL and SDA signals for I2C communication
    initial begin
	$dumpfile("wave.vcd");
	$dumpvars(0, es9821q_controller_tb);
    end

endmodule
