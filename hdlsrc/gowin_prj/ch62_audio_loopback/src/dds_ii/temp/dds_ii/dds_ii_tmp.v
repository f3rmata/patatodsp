//Copyright (C)2014-2024 Gowin Semiconductor Corporation.
//All rights reserved.
//File Title: Template file for instantiation
//Tool Version: V1.9.10.02
//Part Number: GW5A-LV25UG324C2/I1
//Device: GW5A-25
//Device Version: A
//Created Time: Tue Nov 12 12:25:18 2024

//Change the instance name and port connections to the signal names
//--------Copy here to design--------

	DDS_II_Top your_instance_name(
		.clk_i(clk_i), //input clk_i
		.rst_n_i(rst_n_i), //input rst_n_i
		.phase_valid_i(phase_valid_i), //input phase_valid_i
		.phase_i(phase_i), //input [8:0] phase_i
		.sine_o(sine_o), //output [8:0] sine_o
		.data_valid_o(data_valid_o) //output data_valid_o
	);

//--------Copy end-------------------
