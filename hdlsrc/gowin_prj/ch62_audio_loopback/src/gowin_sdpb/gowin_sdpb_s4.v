//Copyright (C)2014-2024 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: IP file
//Tool Version: V1.9.10.02
//Part Number: GW5A-LV25UG324C2/I1
//Device: GW5A-25
//Device Version: A
//Created Time: Mon Nov 11 01:57:19 2024

module Gowin_SDPB_S4 (dout, clka, cea, clkb, ceb, oce, reset, ada, din, adb);

output [15:0] dout;
input clka;
input cea;
input clkb;
input ceb;
input oce;
input reset;
input [13:0] ada;
input [15:0] din;
input [13:0] adb;

wire [29:0] sdpb_inst_0_dout_w;
wire [1:0] sdpb_inst_0_dout;
wire [29:0] sdpb_inst_1_dout_w;
wire [3:2] sdpb_inst_1_dout;
wire [29:0] sdpb_inst_2_dout_w;
wire [5:4] sdpb_inst_2_dout;
wire [29:0] sdpb_inst_3_dout_w;
wire [7:6] sdpb_inst_3_dout;
wire [23:0] sdpb_inst_4_dout_w;
wire [7:0] sdpb_inst_4_dout;
wire [29:0] sdpb_inst_5_dout_w;
wire [9:8] sdpb_inst_5_dout;
wire [29:0] sdpb_inst_6_dout_w;
wire [11:10] sdpb_inst_6_dout;
wire [29:0] sdpb_inst_7_dout_w;
wire [13:12] sdpb_inst_7_dout;
wire [29:0] sdpb_inst_8_dout_w;
wire [15:14] sdpb_inst_8_dout;
wire [23:0] sdpb_inst_9_dout_w;
wire [15:8] sdpb_inst_9_dout;
wire dff_q_0;
wire gw_gnd;

assign gw_gnd = 1'b0;

SDPB sdpb_inst_0 (
    .DO({sdpb_inst_0_dout_w[29:0],sdpb_inst_0_dout[1:0]}),
    .CLKA(clka),
    .CEA(cea),
    .CLKB(clkb),
    .CEB(ceb),
    .OCE(oce),
    .RESET(reset),
    .BLKSELA({gw_gnd,gw_gnd,ada[13]}),
    .BLKSELB({gw_gnd,gw_gnd,adb[13]}),
    .ADA({ada[12:0],gw_gnd}),
    .DI({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,din[1:0]}),
    .ADB({adb[12:0],gw_gnd})
);

defparam sdpb_inst_0.READ_MODE = 1'b0;
defparam sdpb_inst_0.BIT_WIDTH_0 = 2;
defparam sdpb_inst_0.BIT_WIDTH_1 = 2;
defparam sdpb_inst_0.BLK_SEL_0 = 3'b000;
defparam sdpb_inst_0.BLK_SEL_1 = 3'b000;
defparam sdpb_inst_0.RESET_MODE = "ASYNC";

SDPB sdpb_inst_1 (
    .DO({sdpb_inst_1_dout_w[29:0],sdpb_inst_1_dout[3:2]}),
    .CLKA(clka),
    .CEA(cea),
    .CLKB(clkb),
    .CEB(ceb),
    .OCE(oce),
    .RESET(reset),
    .BLKSELA({gw_gnd,gw_gnd,ada[13]}),
    .BLKSELB({gw_gnd,gw_gnd,adb[13]}),
    .ADA({ada[12:0],gw_gnd}),
    .DI({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,din[3:2]}),
    .ADB({adb[12:0],gw_gnd})
);

defparam sdpb_inst_1.READ_MODE = 1'b0;
defparam sdpb_inst_1.BIT_WIDTH_0 = 2;
defparam sdpb_inst_1.BIT_WIDTH_1 = 2;
defparam sdpb_inst_1.BLK_SEL_0 = 3'b000;
defparam sdpb_inst_1.BLK_SEL_1 = 3'b000;
defparam sdpb_inst_1.RESET_MODE = "ASYNC";

SDPB sdpb_inst_2 (
    .DO({sdpb_inst_2_dout_w[29:0],sdpb_inst_2_dout[5:4]}),
    .CLKA(clka),
    .CEA(cea),
    .CLKB(clkb),
    .CEB(ceb),
    .OCE(oce),
    .RESET(reset),
    .BLKSELA({gw_gnd,gw_gnd,ada[13]}),
    .BLKSELB({gw_gnd,gw_gnd,adb[13]}),
    .ADA({ada[12:0],gw_gnd}),
    .DI({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,din[5:4]}),
    .ADB({adb[12:0],gw_gnd})
);

defparam sdpb_inst_2.READ_MODE = 1'b0;
defparam sdpb_inst_2.BIT_WIDTH_0 = 2;
defparam sdpb_inst_2.BIT_WIDTH_1 = 2;
defparam sdpb_inst_2.BLK_SEL_0 = 3'b000;
defparam sdpb_inst_2.BLK_SEL_1 = 3'b000;
defparam sdpb_inst_2.RESET_MODE = "ASYNC";

SDPB sdpb_inst_3 (
    .DO({sdpb_inst_3_dout_w[29:0],sdpb_inst_3_dout[7:6]}),
    .CLKA(clka),
    .CEA(cea),
    .CLKB(clkb),
    .CEB(ceb),
    .OCE(oce),
    .RESET(reset),
    .BLKSELA({gw_gnd,gw_gnd,ada[13]}),
    .BLKSELB({gw_gnd,gw_gnd,adb[13]}),
    .ADA({ada[12:0],gw_gnd}),
    .DI({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,din[7:6]}),
    .ADB({adb[12:0],gw_gnd})
);

defparam sdpb_inst_3.READ_MODE = 1'b0;
defparam sdpb_inst_3.BIT_WIDTH_0 = 2;
defparam sdpb_inst_3.BIT_WIDTH_1 = 2;
defparam sdpb_inst_3.BLK_SEL_0 = 3'b000;
defparam sdpb_inst_3.BLK_SEL_1 = 3'b000;
defparam sdpb_inst_3.RESET_MODE = "ASYNC";

SDPB sdpb_inst_4 (
    .DO({sdpb_inst_4_dout_w[23:0],sdpb_inst_4_dout[7:0]}),
    .CLKA(clka),
    .CEA(cea),
    .CLKB(clkb),
    .CEB(ceb),
    .OCE(oce),
    .RESET(reset),
    .BLKSELA({ada[13],ada[12],ada[11]}),
    .BLKSELB({adb[13],adb[12],adb[11]}),
    .ADA({ada[10:0],gw_gnd,gw_gnd,gw_gnd}),
    .DI({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,din[7:0]}),
    .ADB({adb[10:0],gw_gnd,gw_gnd,gw_gnd})
);

defparam sdpb_inst_4.READ_MODE = 1'b0;
defparam sdpb_inst_4.BIT_WIDTH_0 = 8;
defparam sdpb_inst_4.BIT_WIDTH_1 = 8;
defparam sdpb_inst_4.BLK_SEL_0 = 3'b100;
defparam sdpb_inst_4.BLK_SEL_1 = 3'b100;
defparam sdpb_inst_4.RESET_MODE = "ASYNC";

SDPB sdpb_inst_5 (
    .DO({sdpb_inst_5_dout_w[29:0],sdpb_inst_5_dout[9:8]}),
    .CLKA(clka),
    .CEA(cea),
    .CLKB(clkb),
    .CEB(ceb),
    .OCE(oce),
    .RESET(reset),
    .BLKSELA({gw_gnd,gw_gnd,ada[13]}),
    .BLKSELB({gw_gnd,gw_gnd,adb[13]}),
    .ADA({ada[12:0],gw_gnd}),
    .DI({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,din[9:8]}),
    .ADB({adb[12:0],gw_gnd})
);

defparam sdpb_inst_5.READ_MODE = 1'b0;
defparam sdpb_inst_5.BIT_WIDTH_0 = 2;
defparam sdpb_inst_5.BIT_WIDTH_1 = 2;
defparam sdpb_inst_5.BLK_SEL_0 = 3'b000;
defparam sdpb_inst_5.BLK_SEL_1 = 3'b000;
defparam sdpb_inst_5.RESET_MODE = "ASYNC";

SDPB sdpb_inst_6 (
    .DO({sdpb_inst_6_dout_w[29:0],sdpb_inst_6_dout[11:10]}),
    .CLKA(clka),
    .CEA(cea),
    .CLKB(clkb),
    .CEB(ceb),
    .OCE(oce),
    .RESET(reset),
    .BLKSELA({gw_gnd,gw_gnd,ada[13]}),
    .BLKSELB({gw_gnd,gw_gnd,adb[13]}),
    .ADA({ada[12:0],gw_gnd}),
    .DI({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,din[11:10]}),
    .ADB({adb[12:0],gw_gnd})
);

defparam sdpb_inst_6.READ_MODE = 1'b0;
defparam sdpb_inst_6.BIT_WIDTH_0 = 2;
defparam sdpb_inst_6.BIT_WIDTH_1 = 2;
defparam sdpb_inst_6.BLK_SEL_0 = 3'b000;
defparam sdpb_inst_6.BLK_SEL_1 = 3'b000;
defparam sdpb_inst_6.RESET_MODE = "ASYNC";

SDPB sdpb_inst_7 (
    .DO({sdpb_inst_7_dout_w[29:0],sdpb_inst_7_dout[13:12]}),
    .CLKA(clka),
    .CEA(cea),
    .CLKB(clkb),
    .CEB(ceb),
    .OCE(oce),
    .RESET(reset),
    .BLKSELA({gw_gnd,gw_gnd,ada[13]}),
    .BLKSELB({gw_gnd,gw_gnd,adb[13]}),
    .ADA({ada[12:0],gw_gnd}),
    .DI({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,din[13:12]}),
    .ADB({adb[12:0],gw_gnd})
);

defparam sdpb_inst_7.READ_MODE = 1'b0;
defparam sdpb_inst_7.BIT_WIDTH_0 = 2;
defparam sdpb_inst_7.BIT_WIDTH_1 = 2;
defparam sdpb_inst_7.BLK_SEL_0 = 3'b000;
defparam sdpb_inst_7.BLK_SEL_1 = 3'b000;
defparam sdpb_inst_7.RESET_MODE = "ASYNC";

SDPB sdpb_inst_8 (
    .DO({sdpb_inst_8_dout_w[29:0],sdpb_inst_8_dout[15:14]}),
    .CLKA(clka),
    .CEA(cea),
    .CLKB(clkb),
    .CEB(ceb),
    .OCE(oce),
    .RESET(reset),
    .BLKSELA({gw_gnd,gw_gnd,ada[13]}),
    .BLKSELB({gw_gnd,gw_gnd,adb[13]}),
    .ADA({ada[12:0],gw_gnd}),
    .DI({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,din[15:14]}),
    .ADB({adb[12:0],gw_gnd})
);

defparam sdpb_inst_8.READ_MODE = 1'b0;
defparam sdpb_inst_8.BIT_WIDTH_0 = 2;
defparam sdpb_inst_8.BIT_WIDTH_1 = 2;
defparam sdpb_inst_8.BLK_SEL_0 = 3'b000;
defparam sdpb_inst_8.BLK_SEL_1 = 3'b000;
defparam sdpb_inst_8.RESET_MODE = "ASYNC";

SDPB sdpb_inst_9 (
    .DO({sdpb_inst_9_dout_w[23:0],sdpb_inst_9_dout[15:8]}),
    .CLKA(clka),
    .CEA(cea),
    .CLKB(clkb),
    .CEB(ceb),
    .OCE(oce),
    .RESET(reset),
    .BLKSELA({ada[13],ada[12],ada[11]}),
    .BLKSELB({adb[13],adb[12],adb[11]}),
    .ADA({ada[10:0],gw_gnd,gw_gnd,gw_gnd}),
    .DI({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,din[15:8]}),
    .ADB({adb[10:0],gw_gnd,gw_gnd,gw_gnd})
);

defparam sdpb_inst_9.READ_MODE = 1'b0;
defparam sdpb_inst_9.BIT_WIDTH_0 = 8;
defparam sdpb_inst_9.BIT_WIDTH_1 = 8;
defparam sdpb_inst_9.BLK_SEL_0 = 3'b100;
defparam sdpb_inst_9.BLK_SEL_1 = 3'b100;
defparam sdpb_inst_9.RESET_MODE = "ASYNC";

DFFRE dff_inst_0 (
  .Q(dff_q_0),
  .D(adb[13]),
  .CLK(clkb),
  .CE(ceb),
  .RESET(gw_gnd)
);
MUX2 mux_inst_4 (
  .O(dout[0]),
  .I0(sdpb_inst_0_dout[0]),
  .I1(sdpb_inst_4_dout[0]),
  .S0(dff_q_0)
);
MUX2 mux_inst_9 (
  .O(dout[1]),
  .I0(sdpb_inst_0_dout[1]),
  .I1(sdpb_inst_4_dout[1]),
  .S0(dff_q_0)
);
MUX2 mux_inst_14 (
  .O(dout[2]),
  .I0(sdpb_inst_1_dout[2]),
  .I1(sdpb_inst_4_dout[2]),
  .S0(dff_q_0)
);
MUX2 mux_inst_19 (
  .O(dout[3]),
  .I0(sdpb_inst_1_dout[3]),
  .I1(sdpb_inst_4_dout[3]),
  .S0(dff_q_0)
);
MUX2 mux_inst_24 (
  .O(dout[4]),
  .I0(sdpb_inst_2_dout[4]),
  .I1(sdpb_inst_4_dout[4]),
  .S0(dff_q_0)
);
MUX2 mux_inst_29 (
  .O(dout[5]),
  .I0(sdpb_inst_2_dout[5]),
  .I1(sdpb_inst_4_dout[5]),
  .S0(dff_q_0)
);
MUX2 mux_inst_34 (
  .O(dout[6]),
  .I0(sdpb_inst_3_dout[6]),
  .I1(sdpb_inst_4_dout[6]),
  .S0(dff_q_0)
);
MUX2 mux_inst_39 (
  .O(dout[7]),
  .I0(sdpb_inst_3_dout[7]),
  .I1(sdpb_inst_4_dout[7]),
  .S0(dff_q_0)
);
MUX2 mux_inst_44 (
  .O(dout[8]),
  .I0(sdpb_inst_5_dout[8]),
  .I1(sdpb_inst_9_dout[8]),
  .S0(dff_q_0)
);
MUX2 mux_inst_49 (
  .O(dout[9]),
  .I0(sdpb_inst_5_dout[9]),
  .I1(sdpb_inst_9_dout[9]),
  .S0(dff_q_0)
);
MUX2 mux_inst_54 (
  .O(dout[10]),
  .I0(sdpb_inst_6_dout[10]),
  .I1(sdpb_inst_9_dout[10]),
  .S0(dff_q_0)
);
MUX2 mux_inst_59 (
  .O(dout[11]),
  .I0(sdpb_inst_6_dout[11]),
  .I1(sdpb_inst_9_dout[11]),
  .S0(dff_q_0)
);
MUX2 mux_inst_64 (
  .O(dout[12]),
  .I0(sdpb_inst_7_dout[12]),
  .I1(sdpb_inst_9_dout[12]),
  .S0(dff_q_0)
);
MUX2 mux_inst_69 (
  .O(dout[13]),
  .I0(sdpb_inst_7_dout[13]),
  .I1(sdpb_inst_9_dout[13]),
  .S0(dff_q_0)
);
MUX2 mux_inst_74 (
  .O(dout[14]),
  .I0(sdpb_inst_8_dout[14]),
  .I1(sdpb_inst_9_dout[14]),
  .S0(dff_q_0)
);
MUX2 mux_inst_79 (
  .O(dout[15]),
  .I0(sdpb_inst_8_dout[15]),
  .I1(sdpb_inst_9_dout[15]),
  .S0(dff_q_0)
);
endmodule //Gowin_SDPB_S4
