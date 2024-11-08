`timescale 1ns/1ps
module tb ();

    reg clk = 0;
    reg [15:0] u = 0;
    wire signed [16:0] v;

    always #10 clk = ~clk;  // 50MHz clk

    always @(posedge clk) begin
        if (u == 16'd65535) begin
            u <= 16'd0;
        end
        else u <= u + 1'b1;
    end

    initial begin
        $dumpfile("dumped_sin.vcd");
        $dumpvars(0, tb);
        #1000 $finish;
    end


    Cosine_HDL_Optimized UUT
      (.u(u),
       .x(v));

endmodule
