module reverb_fdn_m
  #(
    parameter BUFFER_LEN = 2048,
    parameter DELAY_TAPS = 256
  )(
    input wire           clk,
    input wire           rst_n,
    input signed [15:0]  audio_in,
    // input wire [5:0]   mix,

    output signed [15:0] audio_out
  );


    reg signed [15:0] circular_buffer [BUFFER_LEN-1:0];
    reg [10:0]  buffer_i = 0;  // 2048 length -> 11 bits

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            // for (buffer_i = 0; buffer_i <= 9'd511; buffer_i = buffer_i + 1'b1)
            //   circular_buffer[buffer_i] = 0;
            buffer_i <= 0;
        end else
          begin
              if (buffer_i >= 11'd2047) buffer_i <= 0;
              else buffer_i <= buffer_i + 1'b1;
              circular_buffer[buffer_i] <= audio_in;
          end // else: !if(~rst_n)
    end // always @ (posedge clk or negedge rst_n)
    // circular buffer


    reg signed [15:0] audio_delay_0;
    reg signed [15:0] audio_delay_1;
    reg signed [15:0] audio_delay_2;
    reg signed [15:0] audio_delay_3;
    reg signed [15:0] audio_delay_4;

    always @* begin
        audio_delay_0 = circular_buffer[buffer_i];
        audio_delay_1 = circular_buffer[buffer_i - DELAY_TAPS];
        audio_delay_2 = circular_buffer[buffer_i - 2*DELAY_TAPS];
        audio_delay_3 = circular_buffer[buffer_i - 3*DELAY_TAPS];
        audio_delay_4 = circular_buffer[buffer_i - 4*DELAY_TAPS];
    end


    wire signed [31:0] mix;

    // assign mix = audio_delay_1 + audio_delay_0;

    // assign audio_out = mix[31:16];
    // assign audio_out = audio_delay_0;
    assign audio_out = audio_delay_1 / 2 + audio_delay_0 / 2;

endmodule // reverb_fdn_m


module clk_cnt
  (
   input clk,
   input rst_n,

   output reg clk_div
);

    reg [19:0] cnt = 0;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            clk_div <= 0;
            cnt <= 0;
        end else begin
            if (cnt >= 25000)
              begin
                  cnt <= 0;
                  clk_div <= ~clk_div;
              end
            else cnt <= cnt + 1'b1;
        end // else: !if(~rst_n)

    end

endmodule // clk_div
