module comb_filter_feedforward
    #(
        parameter DELAY = 1024,
        parameter STRENGTH = 5,
        parameter MIX = 0.5
    )(
        input wire [15:0] audio_in,
        input wire clk,
        input wire rst_n,
        output wire [15:0] audio_out
    );

    wire [15:0] audio_wet;

    assign audio_out = audio_in - audio_in / 4 + audio_wet / 4;
    // should be replaced by DSP IP Core.

    circular_buffer
         #(
         .WRITE_DATA_WIDTH(16),
         .WRITE_DATA_DEPTH(2048),

         .READ_DATA_WIDTH(16),
         .READ_DATA_DEPTH(2048),

         .DELAY(DELAY)
         ) cb_inst (
             .audio_dry(audio_in),
             .audio_wet(audio_wet),
             .clk(clk),
             .rst_n(rst_n)
         );

endmodule

