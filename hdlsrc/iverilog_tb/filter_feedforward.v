module filter_feedforward
    #(
        parameter STRENGTH = 5,
        parameter MIX = 0.5
    )(
        input wire [15:0] audio_in,
        input wire clk,
        input wire rst_n,
        output wire [15:0] audio_out
    );

    wire [15:0] audio_delayed = 0;

    wire wr_en = 1;
    wire rd_en = 1;

    // should be replaced by DSP IP Core.
    assign audio_wet = audio_in - audio_in / 2 + audio_delayed / 2;
    assign audio_out = audio_wet;

    circular_buffer
        #(
        .WRITE_DATA_WIDTH(16),
        .WRITE_DATA_DEPTH(2048),

        .READ_DATA_WIDTH(16),
        .READ_DATA_DEPTH(2048),

        .DELAY(128)
        ) cb_inst (
            .buffer_in(audio_in),
            .buffer_out(audio_delayed),
            .wr_en(wr_en),
            .rd_en(rd_en),
            .clk(clk),
            .rst_n(rst_n)
        );

endmodule

