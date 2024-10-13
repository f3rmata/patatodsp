//Copyright (C)2014-2024 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: Template file for instantiation
//Tool Version: V1.9.9.03 Education
//Part Number: GW5A-LV25UG324C2/I1
//Device: GW5A-25
//Device Version: B
//Created Time: Fri Oct 11 16:08:06 2024

//Change the instance name and port connections to the signal names
//--------Copy here to design--------

    Gowin_SDPB your_instance_name(
        .dout(dout), //output [31:0] dout
        .clka(clka), //input clka
        .cea(cea), //input cea
        .clkb(clkb), //input clkb
        .ceb(ceb), //input ceb
        .oce(oce), //input oce
        .reset(reset), //input reset
        .ada(ada), //input [11:0] ada
        .din(din), //input [31:0] din
        .adb(adb) //input [11:0] adb
    );

//--------Copy end-------------------
