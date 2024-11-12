module reverb_fdn_m
  #(
    // parameter BUFFER_LEN = 2048,
    parameter DELAY_TAPS = 11'd1152
  )(
    input wire           clk,
    input wire           rst_n,
    input signed [15:0]  audio_in,
    // input wire [5:0]   mix,
    output signed [15:0] audio_out
  );


    // reg signed [15:0] circular_buffer [BUFFER_LEN-1:0];
    reg [10:0]  buffer_i_s1 = 0;
    reg [11:0]  buffer_i_s2 = 0;
    reg [12:0]  buffer_i_s3 = 0;
    reg [12:0]  buffer_i_s4 = 0;

    reg [10:0]  buffer_i_s1_tapped = 0;
    reg [11:0]  buffer_i_s2_tapped = 0;
    reg [12:0]  buffer_i_s3_tapped = 0;
    reg [12:0]  buffer_i_s4_tapped = 0;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            // for (buffer_i = 0; buffer_i <= 9'd511; buffer_i = buffer_i + 1'b1)
            //   circular_buffer[buffer_i] = 0;
            buffer_i_s1 <= 0;
            buffer_i_s2 <= 0;
            buffer_i_s3 <= 0;
            buffer_i_s4 <= 0;
            buffer_i_s1_tapped <= 0;
            buffer_i_s2_tapped <= 0;
            buffer_i_s3_tapped <= 0;
            buffer_i_s4_tapped <= 0;
        end else
          begin
              if (buffer_i_s1 >= 11'd2047) buffer_i_s1 <= 0;
              else begin
                  buffer_i_s1 <= buffer_i_s1 + 1'b1;
                  buffer_i_s1_tapped <= buffer_i_s1 + DELAY_TAPS;
              end
              if (buffer_i_s2 >= 12'd4095) buffer_i_s2 <= 0;
              else begin
                  buffer_i_s2 <= buffer_i_s2 + 1'b1;
                  buffer_i_s2_tapped <= buffer_i_s2 + 2*DELAY_TAPS;
              end
              if (buffer_i_s3 >= 13'd8191) buffer_i_s3 <= 0;
              else begin
                  buffer_i_s3 <= buffer_i_s3 + 1'b1;
                  buffer_i_s3_tapped <= buffer_i_s3 + 4*DELAY_TAPS;
              end
              if (buffer_i_s4 >= 13'd8191) buffer_i_s4 <= 0;
              else begin
                  buffer_i_s4 <= buffer_i_s4 + 1'b1;
                  buffer_i_s4_tapped <= buffer_i_s4 + 6*DELAY_TAPS;
              end
              // circular_buffer[buffer_i] <= audio_in;
          end // else: !if(~rst_n)
    end // always @ (posedge clk or negedge rst_n)
    // circular buffer

    wire signed [15:0] audio_delay_0;
    wire signed [15:0] audio_delay_1;
    wire signed [15:0] audio_delay_2;
    wire signed [15:0] audio_delay_3;
    wire signed [15:0] audio_delay_4;

    reg signed [15:0] audio_in_s0;
    reg signed [15:0] audio_in_s1;
    reg signed [15:0] audio_in_s2;
    reg signed [15:0] audio_in_s3;
    reg signed [15:0] audio_in_s4;


    Gowin_SDPB_S1 cb_s1
      (
        .dout(audio_delay_1), //output [15:0] dout
        .clka(clk), //input clka
        .cea(1'b1), //input cea
        .clkb(clk), //input clkb
        .ceb(1'b1), //input ceb
        .reset(~rst_n), //input reset
        .ada(buffer_i_s1_tapped), //input [10:0] ada
        .din(audio_in_s1), //input [15:0] din
        .adb(buffer_i_s1) //input [10:0] adb
    );

    Gowin_SDPB_S2 cb_s2
      (
        .dout(audio_delay_2), //output [15:0] dout
        .clka(clk), //input clka
        .cea(1'b1), //input cea
        .clkb(clk), //input clkb
        .ceb(1'b1), //input ceb
        .reset(~rst_n), //input reset
        .ada(buffer_i_s2_tapped), //input [10:0] ada
        .din(audio_in_s2), //input [15:0] din
        .adb(buffer_i_s2) //input [10:0] adb
    );

    Gowin_SDPB_S3 cb_s3
      (
        .dout(audio_delay_3), //output [15:0] dout
        .clka(clk), //input clka
        .cea(1'b1), //input cea
        .clkb(clk), //input clkb
        .ceb(1'b1), //input ceb
        .reset(~rst_n), //input reset
        .ada(buffer_i_s3_tapped), //input [10:0] ada
        .din(audio_in_s3), //input [15:0] din
        .adb(buffer_i_s3) //input [10:0] adb
    );

    Gowin_SDPB_S4 cb_s4
      (
        .dout(audio_delay_4), //output [15:0] dout
        .clka(clk), //input clka
        .cea(1'b1), //input cea
        .clkb(clk), //input clkb
        .ceb(1'b1), //input ceb
        .reset(~rst_n), //input reset
        .ada(buffer_i_s4_tapped), //input [10:0] ada
        .din(audio_in_s4), //input [15:0] din
        .adb(buffer_i_s4) //input [10:0] adb
    );

/* -----\/----- EXCLUDED -----\/-----
    wire [31:0] sum_s1;
    wire signed [31:0] sum_s2;
    wire signed [31:0] sum_s3;
    wire signed [31:0] sum_s4;

    assign sum_s1 = audio_delay_1 * 16 + audio_in * 16;
    assign sum_s2 = audio_delay_2 / 16'd4 + audio_in;
    assign sum_s3 = audio_delay_3 / 16'd8 + audio_in;
    assign sum_s4 = audio_delay_4 / 16'd8 + audio_in;

    assign audio_in_s1 = sum_s1 >> 16;
 -----/\----- EXCLUDED -----/\----- */


    // Hadamard matrix multiply.

    reg signed [31:0]  h_s1;
    reg signed [31:0]  h_s2;
    reg signed [31:0]  h_s3;
    reg signed [31:0]  h_s4;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            h_s1 <= 0;
            h_s2 <= 0;
            h_s3 <= 0;
            h_s4 <= 0;
            audio_in_s1 <= 0;
            audio_in_s2 <= 0;
            audio_in_s3 <= 0;
            audio_in_s4 <= 0;
        end else
          begin
              //audio_in_s0 <= audio_in;
              audio_in_s1 <= h_s1 >> 1;
              audio_in_s2 <= h_s2 >> 1;
              audio_in_s3 <= h_s3 >> 1;
              audio_in_s4 <= h_s4 >> 1;
              h_s1 <= $signed(audio_delay_0
                      + (audio_delay_1 + audio_delay_2 + audio_delay_3 + audio_delay_4) / 2);
              h_s2 <= $signed(audio_delay_0
                       + (audio_delay_1 - audio_delay_2 + audio_delay_3 - audio_delay_4) / 2);
              h_s3 <= $signed(audio_delay_0
                       + (audio_delay_1 + audio_delay_2 - audio_delay_3 - audio_delay_4) / 2);
              h_s4 <= $signed(audio_delay_0
                       + (audio_delay_1 - audio_delay_2 - audio_delay_3 + audio_delay_4) / 2);
          end // else: !if(~rst_n)
    end // always @ (posedge clk or negedge rst_n)

/* -----\/----- EXCLUDED -----\/-----
    assign h_s1 = audio_delay_1 + audio_delay_2 + audio_delay_3 + audio_delay_4;
    assign h_s2 = audio_delay_1 - audio_delay_2 + audio_delay_3 - audio_delay_4;
    assign h_s3 = audio_delay_1 + audio_delay_2 - audio_delay_3 - audio_delay_4;
    assign h_s4 = audio_delay_1 - audio_delay_2 - audio_delay_3 + audio_delay_4;
 -----/\----- EXCLUDED -----/\----- */

    assign audio_delay_0 = audio_in;

    // assign mix = audio_delay_1 + audio_delay_0;

    wire signed [31:0] mix;
    reg signed [31:0] mix_d;
    wire signed [31:0] mix_o;

    assign mix = $signed(audio_delay_0 / 2
                         + (audio_delay_1 + audio_delay_4
                            + audio_delay_2 + audio_delay_3) / 4);

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            mix_d <= 0;
        end
        else begin
            mix_d <= mix;
        end
    end


    assign mix_o = mix_d + mix / 32;
    // assign audio_out = mix[31:16];
    //assign audio_out = audio_delay_1;
    assign audio_out = mix_o;
    //assign audio_out = (mix > 32767) ? 32767 : (mix < -32768) ? -32768 : mix[31:16];

/* -----\/----- EXCLUDED -----\/-----
    always @* begin
        audio_delay_0 = circular_buffer[buffer_i];
        audio_delay_1 = circular_buffer[buffer_i - DELAY_TAPS];
        audio_delay_2 = circular_buffer[buffer_i - 2*DELAY_TAPS];
        audio_delay_3 = circular_buffer[buffer_i - 3*DELAY_TAPS];
        audio_delay_4 = circular_buffer[buffer_i - 4*DELAY_TAPS];
    end
 -----/\----- EXCLUDED -----/\----- */


endmodule // reverb_fdn_m

/* -----\/----- EXCLUDED -----\/-----
module matrix_mult (A,B,Result);

    input [143:0] A;
    input [143:0] B;
    output [143:0] Result;

    reg [143:0]    Result;
    reg signed [15:0]     A1 [0:2][0:2];
    reg signed [15:0]     B1 [0:2][0:2];
    reg signed [15:0]     Res1 [0:2][0:2];

    integer        i,j,k;

    always@ (A or B)
      begin
          //We convert the 1D arrays into 2D
          {A1[0][0],A1[0][1],A1[0][2],A1[1][0],A1[1][1],A1[1][2],A1[2][0],A1[2][1],A1[2][2]} = A;
          {B1[0][0],B1[0][1],B1[0][2],B1[1][0],B1[1][1],B1[1][2],B1[2][0],B1[2][1],B1[2][2]} = B;
          {Res1[0][0],Res1[0][1],Res1[0][2],Res1[1][0],Res1[1][1],Res1[1][2],Res1[2][0],Res1[2][1],Res1[2][2]} = 144'd0;

          i=0; j=0; k=0;

          //$display ("Multiplying");

          for(i=0;i<3;i=i+1)
            begin
                for(j=0;j<3;j=j+1)
                  begin
                      for(k=0;k<3;k=k+1)
                        begin
                            Res1[i][j]=Res1[i][j]+ (A1[i][k]*B1[k][j]);
                        end
                  end
            end

          Result = {Res1[0][0],Res1[0][1],Res1[0][2],Res1[1][0],Res1[1][1],Res1[1][2],Res1[2][0],Res1[2][1],Res1[2][2]};
      end

endmodule

 -----/\----- EXCLUDED -----/\----- */

/* -----\/----- EXCLUDED -----\/-----
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
 -----/\----- EXCLUDED -----/\----- */
