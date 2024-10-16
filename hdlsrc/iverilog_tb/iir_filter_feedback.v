module iir_filter_feedback 
    #(
        parameter STRENGTH = 5,
        parameter MIX = 0.5
    )(
        input wire [15:0] audio_in,
        input wire clk,
        input wire rst_n,

        output wire [15:0] audio_out
    );

    reg [15:0] audio_s1 = 0;
    reg [15:0] audio_s2 = 0;
    reg [15:0] audio_s3 = 0;
    reg [15:0] audio_s4 = 0;
    reg [15:0] audio_s5 = 0;

    wire [15:0] audio_delayed_s1;
    wire [15:0] audio_delayed_s2;
    wire [15:0] audio_delayed_s3;
    wire [15:0] audio_delayed_s4;
    wire [15:0] audio_delayed_s5;

    reg wr_en = 1;
    reg rd_en = 1;
    wire rd_valid_s1;
    wire rd_valid_s2;
    wire rd_valid_s3;

    // integer b1 = 0.8;
    // integer b2 = 0.5;
    // integer b3 = 0;

    // should be replaced by DSP IP Core.
    always @(posedge clk or negedge rst_n) begin
        if ( !rst_n ) begin
            audio_s1 <= 0;
        end else begin
            if (rd_valid_s1)
                audio_s1 <= audio_in + audio_delayed_s1 / 2;
            else begin
                audio_s1 <= audio_in;
            end
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if ( !rst_n ) begin
            audio_s2 <= 0;
        end else begin
            if (rd_valid_s2)
                audio_s2 <= audio_in + audio_delayed_s2 / 4;
            else begin
                audio_s2 <= audio_in;
            end
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if ( !rst_n ) begin
            audio_s3 <= 0;
        end else begin
            if (rd_valid_s3)
                audio_s3 <= audio_in + audio_delayed_s3 / 2;
            else begin
                audio_s3 <= audio_in;
            end
        end
    end

    assign audio_out = audio_s1 + audio_s2 + audio_s3;

    circular_buffer
        #(
        .WRITE_DATA_WIDTH(16),
        .WRITE_DATA_DEPTH(4096),

        .READ_DATA_WIDTH(16),
        .READ_DATA_DEPTH(4096),

        .DELAY(50)
        ) cb_inst_s1 (
            .buffer_in(audio_s1),
            .buffer_out(audio_delayed_s1),
            .wr_en(wr_en),
            .rd_en(rd_en),
            .rd_valid(rd_valid_s1),
            .clk(clk),
            .rst_n(rst_n)
        );

    circular_buffer
        #(
        .WRITE_DATA_WIDTH(16),
        .WRITE_DATA_DEPTH(4096),

        .READ_DATA_WIDTH(16),
        .READ_DATA_DEPTH(4096),

        .DELAY(100)
        ) cb_inst_s2 (
            .buffer_in(audio_s2),
            .buffer_out(audio_delayed_s2),
            .wr_en(wr_en),
            .rd_en(rd_en),
            .rd_valid(rd_valid_s2),
            .clk(clk),
            .rst_n(rst_n)
        );

    circular_buffer
        #(
        .WRITE_DATA_WIDTH(16),
        .WRITE_DATA_DEPTH(4096),

        .READ_DATA_WIDTH(16),
        .READ_DATA_DEPTH(4096),

        .DELAY(150)
        ) cb_inst_s3 (
            .buffer_in(audio_s3),
            .buffer_out(audio_delayed_s3),
            .wr_en(wr_en),
            .rd_en(rd_en),
            .rd_valid(rd_valid_s3),
            .clk(clk),
            .rst_n(rst_n)
        );

endmodule
