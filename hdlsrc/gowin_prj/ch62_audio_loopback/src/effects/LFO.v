module LFO
  (
   input wire        clk,
   input wire        rst_n,
   input wire [29:0]  period,

   output wire       out_valid,
   output wire [8:0] sin_out
);

    reg [29:0] clk_cnt = 0;

    reg [8:0]  phase = 0;
    reg        phase_valid = 0;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            phase_valid <= 0;
            phase <= 0;
            clk_cnt <= 0;
        end else begin
            if (clk_cnt >= period) begin
                clk_cnt <= 0;
                phase_valid <= 1'b1;
                if (phase >= 9'd511) begin
                    phase <= 0;
                    phase_valid <= 0;
                end else phase <= phase + 1'b1;
            end else clk_cnt <= clk_cnt + 1'b1;
        end
    end

    wire [8:0] sin_dds;
    assign sin_out = 9'd32 - sin_dds;

    DDS_II_Top LFO_DDS
      (
       .clk_i(clk), //input clk_i
       .rst_n_i(rst_n), //input rst_n_i
       .phase_valid_i(phase_valid), //input phase_valid_i
       .phase_i(phase), //input [5:0] phase_i
       .sine_o(sin_dds), //output [5:0] sine_o
       .data_valid_o(data_valid) //output data_valid_o
       );


/* -----\/----- EXCLUDED -----\/-----
    DDS_II_Top LFO_DDS
      (
       .clk_i(clk), //input clk_i
       .rst_n_i(rst_n), //input rst_n_i
       .phase_valid_i(phase_valid), //input phase_valid_i
       .phase_i(phase), //input [11:0] phase_i
       .cosine_o(sin_out), //output [11:0] cosine_o
       .data_valid_o(out_valid) //output data_valid_o
       );

 -----/\----- EXCLUDED -----/\----- */
endmodule // LFO
