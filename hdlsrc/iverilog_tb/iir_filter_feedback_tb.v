`timescale 1ns/10ps

module iir_filter_feedback_tb ();

    reg clk = 0;
    reg rst_n = 1;
    reg [15:0] audio_in = 0;
    wire [15:0] audio_out;

    reg [15:0] sin [2047:0];
    reg [15:0] audio [2047:0];
    reg [11:0] addr = 0;

    initial begin
	$readmemh("sin.txt", sin, 0, 2047);
	// $readmemb("audio.txt", audio); 
	// 48kHz 16bit test file.
	$dumpfile("wave.vcd");
	$dumpvars(0, iir_filter_feedback_tb);
	#1000000 $finish;
    end

    always #10 begin 
	clk = ~clk;
	audio_in = sin[addr];
	if (addr == 2047) addr = 0;
	else addr = addr + 1'b1;
    end

    iir_filter_feedback
	#() UUT (
	    .audio_in(audio_in),
	    .audio_out(audio_out),
	    .clk(clk),
	    .rst_n(rst_n)
	);

endmodule
