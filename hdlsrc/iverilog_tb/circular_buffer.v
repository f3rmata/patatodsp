// concept proof delay model,
// dual port ram should be replaced by DDR in future.

module circular_buffer 
    #(
	parameter WRITE_DATA_WIDTH = 32,
	parameter WRITE_DATA_DEPTH = 384000, 

	parameter READ_DATA_WIDTH = 32,
	parameter READ_DATA_DEPTH = 384000,

	parameter DELAY = 1
    )(
	input wire [WRITE_DATA_WIDTH-1:0] buffer_in,
	input wire wr_en,
	input wire rd_en,
	input wire clk,
	input wire rst_n,

	output reg [READ_DATA_WIDTH-1:0] buffer_out,
	output reg rd_valid
    );

    // simple dualport ram.
    reg [WRITE_DATA_WIDTH-1:0] ram [WRITE_DATA_DEPTH-1:0];

    always @(posedge clk or negedge rst_n) begin
	if ( !rst_n ) begin
	    ram[wr_addr] <= 0;
	end else begin
	    if ( wr_en ) begin
		ram[wr_addr] <= buffer_in;
	    end
	end
    end

    always @(posedge clk or negedge rst_n) begin
	if ( !rst_n ) begin
	    ram[rd_addr] <= 0;
	end else begin
	    if ( rd_en ) begin
		buffer_out <= ram[rd_addr];
	    end
	end
    end

    reg [$clog2(WRITE_DATA_DEPTH)-1:0] wr_addr = 0;
    reg [$clog2(READ_DATA_DEPTH)-1:0] rd_addr = 0;

    // address controller.
    always @(posedge clk or negedge rst_n) begin
	if ( !rst_n ) begin
	    wr_addr <= 0;
	    rd_addr <= 0;
	end else begin 
	    if ( wr_addr == READ_DATA_DEPTH - 1 ) wr_addr = 0;
	    else wr_addr <= wr_addr + 1'b1;
	    rd_addr <= wr_addr - DELAY;
	    if ( rd_addr < wr_addr ) rd_valid <= 1'b1;
	    else rd_valid <= 0;
	end
    end

endmodule
