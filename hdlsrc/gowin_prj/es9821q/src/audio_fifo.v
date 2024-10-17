module audio_fifo (
    input wire [31:0] Data,
    input wire Reset,
    input wire WrClk,
    input wire RdClk,
    input wire WrEn,
    input wire RdEn,
    output wire [8:0] Wnum,
    output wire [8:0] Rnum,
    output wire Almost_Empty,
    output wire Almost_Full,
    output wire [31:0] Q,
    output wire Empty,
    output wire Full
);

    fifo_top audio_fifo_instance (
        .Data(Data),            // input [31:0] Data 输入数据
        .Reset(Reset),          // input Reset 复位信号
        .WrClk(WrClk),          // input WrClk 写时钟
        .RdClk(RdClk),          // input RdClk 读时钟
        .WrEn(WrEn),            // input WrEn 写使能信号
        .RdEn(RdEn),            // input RdEn 读使能信号
        .Wnum(Wnum),            // output [8:0] Wnum 写入数据量指示
        .Rnum(Rnum),            // output [8:0] Rnum 读取数据量指示
        .Almost_Empty(Almost_Empty), // output Almost_Empty 几乎空信号
        .Almost_Full(Almost_Full),   // output Almost_Full 几乎满信号
        .Q(Q),                  // output [31:0] Q 读出的数据
        .Empty(Empty),          // output Empty FIFO 为空指示
        .Full(Full)             // output Full FIFO 已满指示
    );

endmodule
