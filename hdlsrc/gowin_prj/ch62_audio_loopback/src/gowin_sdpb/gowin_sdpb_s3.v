//Copyright (C)2014-2024 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: IP file
//Tool Version: V1.9.10.02
//Part Number: GW5A-LV25UG324C2/I1
//Device: GW5A-25
//Device Version: A
//Created Time: Mon Nov 11 01:54:55 2024

module Gowin_SDPB_S3 (dout, clka, cea, clkb, ceb, oce, reset, ada, din, adb);

output [15:0] dout;
input clka;
input cea;
input clkb;
input ceb;
input oce;
input reset;
input [12:0] ada;
input [15:0] din;
input [12:0] adb;

wire [27:0] sdpb_inst_0_dout_w;
wire [3:0] sdpb_inst_0_dout;
wire [27:0] sdpb_inst_1_dout_w;
wire [7:4] sdpb_inst_1_dout;
wire [27:0] sdpb_inst_2_dout_w;
wire [11:8] sdpb_inst_2_dout;
wire [27:0] sdpb_inst_3_dout_w;
wire [15:12] sdpb_inst_3_dout;
wire [15:0] sdpb_inst_4_dout_w;
wire [15:0] sdpb_inst_4_dout;
wire dff_q_0;
wire gw_vcc;
wire gw_gnd;

assign gw_vcc = 1'b1;
assign gw_gnd = 1'b0;

SDPB sdpb_inst_0 (
    .DO({sdpb_inst_0_dout_w[27:0],sdpb_inst_0_dout[3:0]}),
    .CLKA(clka),
    .CEA(cea),
    .CLKB(clkb),
    .CEB(ceb),
    .OCE(oce),
    .RESET(reset),
    .BLKSELA({gw_gnd,gw_gnd,ada[12]}),
    .BLKSELB({gw_gnd,gw_gnd,adb[12]}),
    .ADA({ada[11:0],gw_gnd,gw_gnd}),
    .DI({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,din[3:0]}),
    .ADB({adb[11:0],gw_gnd,gw_gnd})
);

defparam sdpb_inst_0.READ_MODE = 1'b0;
defparam sdpb_inst_0.BIT_WIDTH_0 = 4;
defparam sdpb_inst_0.BIT_WIDTH_1 = 4;
defparam sdpb_inst_0.BLK_SEL_0 = 3'b000;
defparam sdpb_inst_0.BLK_SEL_1 = 3'b000;
defparam sdpb_inst_0.RESET_MODE = "ASYNC";

SDPB sdpb_inst_1 (
    .DO({sdpb_inst_1_dout_w[27:0],sdpb_inst_1_dout[7:4]}),
    .CLKA(clka),
    .CEA(cea),
    .CLKB(clkb),
    .CEB(ceb),
    .OCE(oce),
    .RESET(reset),
    .BLKSELA({gw_gnd,gw_gnd,ada[12]}),
    .BLKSELB({gw_gnd,gw_gnd,adb[12]}),
    .ADA({ada[11:0],gw_gnd,gw_gnd}),
    .DI({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,din[7:4]}),
    .ADB({adb[11:0],gw_gnd,gw_gnd})
);

defparam sdpb_inst_1.READ_MODE = 1'b0;
defparam sdpb_inst_1.BIT_WIDTH_0 = 4;
defparam sdpb_inst_1.BIT_WIDTH_1 = 4;
defparam sdpb_inst_1.BLK_SEL_0 = 3'b000;
defparam sdpb_inst_1.BLK_SEL_1 = 3'b000;
defparam sdpb_inst_1.RESET_MODE = "ASYNC";

SDPB sdpb_inst_2 (
    .DO({sdpb_inst_2_dout_w[27:0],sdpb_inst_2_dout[11:8]}),
    .CLKA(clka),
    .CEA(cea),
    .CLKB(clkb),
    .CEB(ceb),
    .OCE(oce),
    .RESET(reset),
    .BLKSELA({gw_gnd,gw_gnd,ada[12]}),
    .BLKSELB({gw_gnd,gw_gnd,adb[12]}),
    .ADA({ada[11:0],gw_gnd,gw_gnd}),
    .DI({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,din[11:8]}),
    .ADB({adb[11:0],gw_gnd,gw_gnd})
);

defparam sdpb_inst_2.READ_MODE = 1'b0;
defparam sdpb_inst_2.BIT_WIDTH_0 = 4;
defparam sdpb_inst_2.BIT_WIDTH_1 = 4;
defparam sdpb_inst_2.BLK_SEL_0 = 3'b000;
defparam sdpb_inst_2.BLK_SEL_1 = 3'b000;
defparam sdpb_inst_2.RESET_MODE = "ASYNC";

SDPB sdpb_inst_3 (
    .DO({sdpb_inst_3_dout_w[27:0],sdpb_inst_3_dout[15:12]}),
    .CLKA(clka),
    .CEA(cea),
    .CLKB(clkb),
    .CEB(ceb),
    .OCE(oce),
    .RESET(reset),
    .BLKSELA({gw_gnd,gw_gnd,ada[12]}),
    .BLKSELB({gw_gnd,gw_gnd,adb[12]}),
    .ADA({ada[11:0],gw_gnd,gw_gnd}),
    .DI({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,din[15:12]}),
    .ADB({adb[11:0],gw_gnd,gw_gnd})
);

defparam sdpb_inst_3.READ_MODE = 1'b0;
defparam sdpb_inst_3.BIT_WIDTH_0 = 4;
defparam sdpb_inst_3.BIT_WIDTH_1 = 4;
defparam sdpb_inst_3.BLK_SEL_0 = 3'b000;
defparam sdpb_inst_3.BLK_SEL_1 = 3'b000;
defparam sdpb_inst_3.RESET_MODE = "ASYNC";

SDPB sdpb_inst_4 (
    .DO({sdpb_inst_4_dout_w[15:0],sdpb_inst_4_dout[15:0]}),
    .CLKA(clka),
    .CEA(cea),
    .CLKB(clkb),
    .CEB(ceb),
    .OCE(oce),
    .RESET(reset),
    .BLKSELA({ada[12],ada[11],ada[10]}),
    .BLKSELB({adb[12],adb[11],adb[10]}),
    .ADA({ada[9:0],gw_gnd,gw_gnd,gw_vcc,gw_vcc}),
    .DI({gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,gw_gnd,din[15:0]}),
    .ADB({adb[9:0],gw_gnd,gw_gnd,gw_gnd,gw_gnd})
);

defparam sdpb_inst_4.READ_MODE = 1'b0;
defparam sdpb_inst_4.BIT_WIDTH_0 = 16;
defparam sdpb_inst_4.BIT_WIDTH_1 = 16;
defparam sdpb_inst_4.BLK_SEL_0 = 3'b100;
defparam sdpb_inst_4.BLK_SEL_1 = 3'b100;
defparam sdpb_inst_4.RESET_MODE = "ASYNC";

DFFRE dff_inst_0 (
  .Q(dff_q_0),
  .D(adb[12]),
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
  .I0(sdpb_inst_0_dout[2]),
  .I1(sdpb_inst_4_dout[2]),
  .S0(dff_q_0)
);
MUX2 mux_inst_19 (
  .O(dout[3]),
  .I0(sdpb_inst_0_dout[3]),
  .I1(sdpb_inst_4_dout[3]),
  .S0(dff_q_0)
);
MUX2 mux_inst_24 (
  .O(dout[4]),
  .I0(sdpb_inst_1_dout[4]),
  .I1(sdpb_inst_4_dout[4]),
  .S0(dff_q_0)
);
MUX2 mux_inst_29 (
  .O(dout[5]),
  .I0(sdpb_inst_1_dout[5]),
  .I1(sdpb_inst_4_dout[5]),
  .S0(dff_q_0)
);
MUX2 mux_inst_34 (
  .O(dout[6]),
  .I0(sdpb_inst_1_dout[6]),
  .I1(sdpb_inst_4_dout[6]),
  .S0(dff_q_0)
);
MUX2 mux_inst_39 (
  .O(dout[7]),
  .I0(sdpb_inst_1_dout[7]),
  .I1(sdpb_inst_4_dout[7]),
  .S0(dff_q_0)
);
MUX2 mux_inst_44 (
  .O(dout[8]),
  .I0(sdpb_inst_2_dout[8]),
  .I1(sdpb_inst_4_dout[8]),
  .S0(dff_q_0)
);
MUX2 mux_inst_49 (
  .O(dout[9]),
  .I0(sdpb_inst_2_dout[9]),
  .I1(sdpb_inst_4_dout[9]),
  .S0(dff_q_0)
);
MUX2 mux_inst_54 (
  .O(dout[10]),
  .I0(sdpb_inst_2_dout[10]),
  .I1(sdpb_inst_4_dout[10]),
  .S0(dff_q_0)
);
MUX2 mux_inst_59 (
  .O(dout[11]),
  .I0(sdpb_inst_2_dout[11]),
  .I1(sdpb_inst_4_dout[11]),
  .S0(dff_q_0)
);
MUX2 mux_inst_64 (
  .O(dout[12]),
  .I0(sdpb_inst_3_dout[12]),
  .I1(sdpb_inst_4_dout[12]),
  .S0(dff_q_0)
);
MUX2 mux_inst_69 (
  .O(dout[13]),
  .I0(sdpb_inst_3_dout[13]),
  .I1(sdpb_inst_4_dout[13]),
  .S0(dff_q_0)
);
MUX2 mux_inst_74 (
  .O(dout[14]),
  .I0(sdpb_inst_3_dout[14]),
  .I1(sdpb_inst_4_dout[14]),
  .S0(dff_q_0)
);
MUX2 mux_inst_79 (
  .O(dout[15]),
  .I0(sdpb_inst_3_dout[15]),
  .I1(sdpb_inst_4_dout[15]),
  .S0(dff_q_0)
);
endmodule //Gowin_SDPB_S3
