//Copyright (C)2014-2024 GOWIN Semiconductor Corporation.
//All rights reserved.
//File Title: Timing Constraints file
//Tool Version: V1.9.10.02 
//Created Time: 2024-10-16 17:37:27
create_clock -name clk_50M -period 20 -waveform {0 10} [get_ports {clk}]
