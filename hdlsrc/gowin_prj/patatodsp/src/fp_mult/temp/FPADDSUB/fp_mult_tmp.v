//Copyright (C)2014-2024 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: Template file for instantiation
//Tool Version: V1.9.10.02
//Part Number: GW5A-LV25UG324C2/I1
//Device: GW5A-25
//Device Version: B
//Created Time: Fri Oct 11 17:23:25 2024

//Change the instance name and port connections to the signal names
//--------Copy here to design--------

	FP_Mult_Top your_instance_name(
		.clk(clk), //input clk
		.rstn(rstn), //input rstn
		.data_a(data_a), //input [31:0] data_a
		.data_b(data_b), //input [31:0] data_b
		.overflow(overflow), //output overflow
		.underflow(underflow), //output underflow
		.nan(nan), //output nan
		.zero(zero), //output zero
		.result(result) //output [31:0] result
	);

//--------Copy end-------------------
