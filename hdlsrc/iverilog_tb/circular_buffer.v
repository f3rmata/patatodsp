// concept proof delay model,
// dual port ram should be replaced by DDR in future.

module circular_buffer 
    #(
	parameter WRITE_DATA_WIDTH = 32,
	parameter WRITE_DATA_DEPTH = 384000, 

	parameter READ_DATA_WIDTH = 32,
	parameter READ_DATA_DEPTH = 384000,

	parameter DELAY = 5
    )(
	input wire [WRITE_DATA_WIDTH-1:0] audio_dry,
	input wire clk,
	input wire rst_n,

	output reg [READ_DATA_WIDTH-1:0] audio_wet 
    );

    reg [$clog2(WRITE_DATA_DEPTH)-1:0] wr_addr = 0;
    reg [$clog2(READ_DATA_DEPTH)-1:0] rd_addr = 0;
    wire wr_en = 1;
    wire rd_en = 1;

    // simple dualport ram.
    reg [WRITE_DATA_WIDTH-1:0] ram [WRITE_DATA_DEPTH-1:0];

    always @(posedge clk or negedge rst_n) begin
	if ( !rst_n ) begin
	end else begin
	    if ( wr_en ) begin
		ram[wr_addr] <= audio_dry;
	    end
	end
    end

    always @(posedge clk or negedge rst_n) begin
	if ( !rst_n ) begin
	end else begin
	    if ( rd_en ) begin
		audio_wet <= ram[rd_addr];
	    end
	end
    end

    // address controller.
    always @(posedge clk or negedge rst_n) begin
	if ( !rst_n ) begin
	    wr_addr <= 0;
	    rd_addr <= 0;
	end else begin 
	    if ( wr_addr == READ_DATA_DEPTH - 1 ) wr_addr = 0;
	    else wr_addr <= wr_addr + 1'b1;
	    rd_addr <= wr_addr - DELAY;
	end
    end

endmodule
