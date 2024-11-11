//Copyright (C)2014-2024 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: Template file for instantiation
//Tool Version: V1.9.10.02
//Part Number: GW5A-LV25UG324C2/I1
//Device: GW5A-25
//Device Version: A
//Created Time: Mon Nov 11 01:54:55 2024

//Change the instance name and port connections to the signal names
//--------Copy here to design--------

    Gowin_SDPB_S3 your_instance_name(
        .dout(dout), //output [15:0] dout
        .clka(clka), //input clka
        .cea(cea), //input cea
        .clkb(clkb), //input clkb
        .ceb(ceb), //input ceb
        .oce(oce), //input oce
        .reset(reset), //input reset
        .ada(ada), //input [12:0] ada
        .din(din), //input [15:0] din
        .adb(adb) //input [12:0] adb
    );

//--------Copy end-------------------
