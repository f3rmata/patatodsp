//Copyright (C)2014-2024 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: Template file for instantiation
//Tool Version: V1.9.10.02
//Part Number: GW5A-LV25UG324C2/I1
//Device: GW5A-25
//Device Version: B
//Created Time: Fri Oct 11 17:15:46 2024

//Change the instance name and port connections to the signal names
//--------Copy here to design--------

    Gowin_MULT your_instance_name(
        .dout(dout), //output [41:0] dout
        .a(a), //input [8:0] a
        .b(b), //input [32:0] b
        .clk(clk), //input clk
        .ce(ce), //input ce
        .reset(reset) //input reset
    );

//--------Copy end-------------------
