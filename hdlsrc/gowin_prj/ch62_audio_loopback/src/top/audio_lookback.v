module audio_lookback
  (
   input		 clk,
   input		 reset_n,
   inout		 iic_0_scl,
   inout		 iic_0_sda,
   output		 led,

   input		 I2S_ADCDAT,
   input		 I2S_ADCLRC,
   input		 I2S_BCLK,
   output		 I2S_DACDAT,
   input		 I2S_DACLRC,
   output		 I2S_MCLK
   );
	
	parameter DATA_WIDTH        = 32;     
	
    Gowin_PLL Gowin_PLL(
        .clkout0(I2S_MCLK), //output clkout0
        .clkin(clk) //input clkin
    );
	
 	wire Init_Done;
	WM8960_Init WM8960_Init(
		.Clk(clk),
		.Rst_n(reset_n),
		.I2C_Init_Done(Init_Done),
		.i2c_sclk(iic_0_scl),
		.i2c_sdat(iic_0_sda)
	);
	
	assign led = Init_Done;
	
	reg adcfifo_read;
	wire [DATA_WIDTH - 1:0] adcfifo_readdata;
	wire adcfifo_empty;

	reg dacfifo_write;
	reg [DATA_WIDTH - 1:0] dacfifo_writedata;
	wire dacfifo_full;
	

	always @ (posedge clk or negedge reset_n)
	begin
		if (~reset_n)
		begin
			adcfifo_read <= 1'b0;
		end
		else if (~adcfifo_empty)
		begin
			adcfifo_read <= 1'b1;
		end
		else
		begin
			adcfifo_read <= 1'b0;
		end
	end

	wire [31:0] effect_out;
	wire		out_valid;

	reg [31:0]	effect_flanger_in;
	wire [31:0]	effect_flanger_out;

	reg [29:0]	period = 25000;
	wire [8:0]	lfo_o;

	LFO LFO_inst
	  (
	   .clk(clk),
	   .rst_n(reset_n),
	   .period(period),
	   .out_valid(out_valid),
	   .sin_out(lfo_o)
	   );

	always @(posedge clk or negedge reset_n) begin
		if (!reset_n)
		  effect_flanger_in <= 0;
		else
		  effect_flanger_in <= adcfifo_readdata;
	end

	flanger flanger_inst_l
	  (
	   .clk(clk),
	   .reset_n(reset_n),
	   .delay(lfo_o),
	   .clk_enable(1'b1),
	   .In1(effect_flanger_in[15:0]),
	   .Out1(effect_flanger_out[15:0])
	   );

	flanger flanger_inst_r
	  (
	   .clk(clk),
	   .reset_n(reset_n),
	   .delay(lfo_o),
	   .clk_enable(1'b1),
	   .In1(effect_flanger_in[31:16]),
	   .Out1(effect_flanger_out[31:16])
	   );

	assign effect_out = effect_flanger_out;


	reg [31:0]	effect_echo_in;
	wire [31:0]	effect_echo_out;

	reg [29:0]	period = 25000;
	wire [5:0]	lfo_o;

	LFO LFO_inst
	  (
	   .clk(clk),
	   .rst_n(reset_n),
	   .period(period),
	   .out_valid(out_valid),
	   .sin_out(lfo_o)
	   );


	always @(posedge clk or negedge reset_n) begin
		if (!reset_n)
		  effect_echo_in <= 0;
		else
		  effect_echo_in <= adcfifo_readdata;
	end

	echo_effect_small_delay echo_inst_l
	  (
	   .clk(clk),
	   .reset_n(reset_n),
	   .delay(lfo_o),
	   .clk_enable(1'b1),
	   .audio_in(effect_echo_in[15:0]),
	   .audio_out(effect_echo_out[15:0])
	   );

	echo_effect_small_delay echo_inst_r
	  (
	   .clk(clk),
	   .reset_n(reset_n),
	   .delay(lfo_o),
	   .clk_enable(1'b1),
	   .audio_in(effect_echo_in[31:16]),
	   .audio_out(effect_echo_out[31:16])
	   );

	// assign effect_out = effect_echo_out;

	reg [31:0]	effect_reverb_in;
	wire [31:0]	effect_reverb_out;

	always @(posedge clk or negedge reset_n) begin
		if (!reset_n)
		  effect_reverb_in <= 32'd0;
		else
		  effect_reverb_in <= adcfifo_readdata;
	end

	reverb_fdn_m reverb_inst_l
	  (
	   .clk(clk),
	   .rst_n(reset_n),
	   .audio_in(effect_reverb_in[15:0]),
	   .audio_out(effect_reverb_out[15:0])
		);

	reverb_fdn_m reverb_inst_r
	  (
	   .clk(clk),
	   .rst_n(reset_n),
	   .audio_in(effect_reverb_in[31:16]),
	   .audio_out(effect_reverb_out[31:16])
	   );

	// assign effect_out = effect_reverb_out;

	reg [29:0]	period;
	wire [8:0]	lfo_o;
	reg [31:0]	effect_chorus_in;
	wire [31:0]	effect_chorus_out;

	// assign sin_out = {2'b0,12'd2048 - lfo_o} + 14'd6144;
	// assign dac_clk = clk;

	always @(posedge clk or negedge reset_n) begin
		if (!reset_n)
		  effect_chorus_in <= 32'd0;
		else
		  effect_chorus_in <= adcfifo_readdata;
	end

	LFO LFO_inst
	  (
	   .clk(clk),
	   .rst_n(reset_n),
	   .period(period),
	   .out_valid(out_valid),
	   .sin_out(lfo_o)
	   );

	chorus chorus_inst_l
	  (
	   .clk(clk),
	   .reset_n(reset_n),
	   .audio_in(effect_chorus_in[15:0]),
	   .sin_mod(9'd10),
	   .audio_out(effect_chorus_out[15:0])
	   );

	chorus chorus_inst_r
	  (
	   .clk(clk),
	   .reset_n(reset_n),
	   .audio_in(effect_chorus_in[31:16]),
	   .sin_mod(9'd10),
	   .audio_out(effect_chorus_out[31:16])
	   );

	assign effect_out = effect_chorus_out;


	reg [15:0] Drive = 16'd50;
	reg [31:0]	effect_dist_in;
	wire [31:0]	effect_dist_out;

	always @(posedge clk or negedge reset_n) begin
		if (!reset_n)
		  effect_dist_in <= 32'd0;
		else
		  effect_dist_in <= adcfifo_readdata;
	end

	distortion dist_inst1
	  (.In1(effect_dist_in[15:0]),
	   .Drive(Drive),
	   .Out1(effect_dist_out[15:0]));

	distortion dist_inst2
	  (.In1(effect_dist_in[31:16]),
	   .Drive(Drive),
	   .Out1(effect_dist_out[31:16]));

	assign effect_out = effect_dist_out;



	always @* begin
		if (echo)
		  effect_out = effect_echo_out;
		else if (chorus)
		  effect_out = effect_chorus_out;
		else if (flanger)
		  effect_out = effect_flanger_out;
		else if (reverb)
		  effect_out = effect_reverb_out;
		else if (distortion)
		  effect_out = effect_dist_out;
		else if (loopback)
		  effect_out = audio_lookback;
		else
		  effect_out = audio_loopback;
	end // always @ *

	always @(posedge clk or negedge reset_n) begin
		if(~reset_n)
			dacfifo_write <= 1'd0;
		else if(~dacfifo_full && (~adcfifo_empty)) begin
			dacfifo_write <= 1'd1;
			dacfifo_writedata <= effect_out;
		end
		else begin
			dacfifo_write <= 1'd0;
		end
	end


	i2s_rx 
	#(
		.DATA_WIDTH(DATA_WIDTH) 
	)i2s_rx
	(
		.reset_n(reset_n),
		.bclk(I2S_BCLK),
		.adclrc(I2S_ADCLRC),
		.adcdat(I2S_ADCDAT),
		.adcfifo_rdclk(clk),
		.adcfifo_read(adcfifo_read),
		.adcfifo_empty(adcfifo_empty),
		.adcfifo_readdata(adcfifo_readdata)
	);
	
	i2s_tx
	#(
		 .DATA_WIDTH(DATA_WIDTH)
	)i2s_tx
	(
		 .reset_n(reset_n),
		 .dacfifo_wrclk(clk),
		 .dacfifo_wren(dacfifo_write),
		 .dacfifo_wrdata(dacfifo_writedata),
		 .dacfifo_full(dacfifo_full),
		 .bclk(I2S_BCLK),
		 .daclrc(I2S_DACLRC),
		 .dacdat(I2S_DACDAT)
	);

		 
endmodule
