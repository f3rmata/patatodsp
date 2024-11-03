module clkk    # 
(
    parameter                                           SYS_CLK_FREQ    = 'd50_000_000,         //系统时钟频率
    parameter                                           I2C_CLK         = 'd100_000,            //I2C输出时钟
    parameter                                           SLAVE_ADDR      =  7'h40            //从机地址
)
(
    input                                               sys_clk ,
    input                                               rst_n   ,

    input                                               i2c_start   ,            //I2C开始信号
    output  reg                                         i2c_done    ,            //本次I2C操作完成信号
    output  reg                                         i2c_ack ,                //从机给的ack信号
    output  reg                                         scl ,                    //IIC协议的SCL
    inout                                               sda  ,                    //IIC协议的SDA
    output  reg                                         i2c_drive_clk            //却驱动I2C模块的驱动时钟

);
    localparam                                          Idle                      = 8'b0000_0001; //空闲状态
    localparam                                          Write_slave_addr_state    = 8'b0000_0010; //发送从机器件地址写状态
    localparam                                          Write_byte_addr8_state    = 8'b0000_0100; //发送8位内存地址状态
    localparam                                          Write_data_state          = 8'b0000_1000; //写数据(8 bit)状态
    localparam                                          Stop                      = 8'b0001_0000; //结束I2C操作
    localparam                                          clk_div_cnt_max           = SYS_CLK_FREQ/I2C_CLK/4;//I2C四倍频时钟计数最大值
    reg             [14:0]                              clk_cnt ;               //分频时钟需要的计数器
    
    //生成SCL的四倍频时钟
always @(posedge sys_clk or negedge rst_n) begin
    if(rst_n == 1'b0)begin
        i2c_drive_clk <= 1'b0;
        clk_cnt <= 'd0;
    end
    else if(clk_cnt == clk_div_cnt_max[14:1] - 1)begin
        i2c_drive_clk <= ~i2c_drive_clk;
        clk_cnt <= 'd0;
    end
    else begin
        i2c_drive_clk <= i2c_drive_clk;
        clk_cnt <= clk_cnt + 1'b1;
    end
end
reg         sda_ctrl    ;           //控制sda方向，1的时候sda为输出；0的时候sda为输入
reg         sda_out ;               //sda输出信号
wire        sda_in  ;                //sda输入信号

//控制SDA
assign  sda      = sda_ctrl ? sda_out : 1'bz;
assign  sda_in   = sda;


reg       [7:0]     cur_state   = Idle;     //状态机当前状态
reg       [7:0]     next_state  = Idle;     //状态机下一状态

//三段式第一段，时序电路描述状态转移
always @(posedge i2c_drive_clk or negedge rst_n) begin
    if(rst_n == 1'b0)
        cur_state <= Idle;
    else
        cur_state <= next_state;
end

reg         state_done   ;          //状态机跳转信号

//三段式第二段，组合逻辑描述状态转移条件
always @(*) begin
    case (cur_state)
        Idle: begin
            if(i2c_start == 1'b1)begin                            //如果i2c_start 来临时，就跳入到发送从机地址状态
                next_state = Write_slave_addr_state;
            end
            else begin
                next_state = Idle;
            end
        end

        Write_slave_addr_state:begin                            //如果从机地址写完成，跳入写寄存器地址状态
            if(state_done == 1'b1)begin
                next_state = Write_byte_addr8_state;
            end
            else begin
                next_state = Write_slave_addr_state;
            end
        end

        Write_byte_addr8_state:begin                            //内存地址低8位写完后，跳入写数据状态
            if(state_done == 1'b1)begin    
                    next_state = Write_data_state;
            end
            else 
                next_state = Write_byte_addr8_state;
        end

        Write_data_state:begin                                    //写数据状态，写完成后跳转到停止状态
            if(i2c_done == 1'b1)begin
                next_state = Stop;
            end
            else begin
                next_state = Write_data_state;
            end
        end

        Stop:begin                                                //产生停止信号，然后跳转到空闲状态
            if(state_done == 1'b1)begin
                next_state = Idle;
            end
            else begin
                next_state = Stop;
            end
        end
        default: next_state = Idle;
    endcase
end

reg                                                 wr_rd_flag ;            //读写信号，0的时候为写；1的时候为读   
reg             [6:0]                               clk4_cnt ;              //I2C四倍频时钟周期计数器
reg             [7:0]                               reg_addr_reg;           //寄存器地址缓存
reg             [7:0]                               data_reg;               //写数据缓存
reg             [3:0]                               reg_data_index;         //寄存器和数据的索引
// 在多个寄存器和数据之间切换
always @(*) begin
    case (reg_data_index)
        4'd0: begin reg_addr_reg = 8'h1D; data_reg = 8'h00; end
        4'd1: begin reg_addr_reg = 8'h1A; data_reg = 8'h11; end
        4'd2: begin reg_addr_reg = 8'h03; data_reg = 8'b00000000; end
        4'd3: begin reg_addr_reg = 8'h04; data_reg = 8'b10000010; end
        4'd4: begin reg_addr_reg = 8'h01; data_reg = 8'h00; end
        4'd5: begin reg_addr_reg = 8'h02; data_reg = 8'h03; end
        4'd6: begin reg_addr_reg = 8'h00; data_reg = 8'b00000010; end
        default: begin reg_addr_reg = 8'h00; data_reg = 8'h00; end
    endcase
end
//三段式第三段，时序逻辑描述状态输出
always @(posedge i2c_drive_clk or negedge rst_n) begin
    if(rst_n == 1'b0)begin
        i2c_done <= 1'b0;
        i2c_ack <= 1'b0;
        scl <=  1'b1;
        sda_ctrl <= 1'b1;       
        sda_out <= 1'b1;           
        state_done   <= 1'b0;      
        wr_rd_flag <= 1'b0;      
        clk4_cnt <= 'd0;          
        reg_addr_reg = 'd0;
        data_reg = 'd0;
        reg_data_index <= 'd0;
    end
    else begin
        clk4_cnt <= clk4_cnt + 1'b1;
        case (cur_state)
            Idle: begin
                if(i2c_start ==1'b1)begin               //开始传输时，加载第一个寄存器地址和数据
                    clk4_cnt <= 'd0;
                end
                else begin
                    clk4_cnt <= 'd0;
                    scl <=  1'b1;
                    sda_ctrl <= 1'b1;
                    sda_out <= 1'b1; 
                    i2c_done <= 1'b0;
                    i2c_ack <= 1'b0;
                end
            end

            Write_slave_addr_state:begin
                case (clk4_cnt)
                    'd1:    sda_out <= 1'b0;            //SCL为高电平时，拉低SDA为起始信号
                    'd3:    scl <= 1'b0;
                    'd4:    sda_out <= SLAVE_ADDR[6];   //低电平时传输器件地址低6位
                    'd5:    scl <= 1'b1;
                    'd7:    scl <= 1'b0;
                    'd8:    sda_out <= SLAVE_ADDR[5];   //低电平时传输器件地址低5位
                    'd9:    scl <= 1'b1;
                    'd11:   scl <= 1'b0;
                    'd12:   sda_out <= SLAVE_ADDR[4];   //低电平时传输器件地址低4位
                    'd13:   scl <= 1'b1;
                    'd15:   scl <= 1'b0;
                    'd16:   sda_out <= SLAVE_ADDR[3];   //低电平时传输器件地址低3位
                    'd17:   scl <= 1'b1;
                    'd19:   scl <= 1'b0;
                    'd20:   sda_out <= SLAVE_ADDR[2];   //低电平时传输器件地址低2位
                    'd21:   scl <= 1'b1;
                    'd23:   scl <= 1'b0;
                    'd24:   sda_out <= SLAVE_ADDR[1];   //低电平时传输器件地址低1位
                    'd25:   scl <= 1'b1;
                    'd27:   scl <= 1'b0;
                    'd28:   sda_out <= SLAVE_ADDR[0];   //低电平时传输器件地址低0位
                    'd29:   scl <= 1'b1;
                    'd31:   scl <= 1'b0;
                    'd32:   sda_out <= 1'b0;            //写命令
                    'd33:   scl <= 1'b1;
                    'd35:   scl <= 1'b0;
                    'd36:   begin
                            sda_out <= 1'b1;            
                            sda_ctrl<= 1'b0;            //释放sda总线 
                    end
                    'd37:   scl <= 1'b1;
                    'd38:   begin
                            state_done <= 1'b1;
                            if(sda_in == 1'b1)          //如果第9位sda为低电平，则表示从机应答成功,状态机跳转 
                                i2c_ack <= 1'b0;
                            else
                                i2c_ack <= 1'b1;
                    end
                    'd39:   begin
                            state_done <= 1'b0;         //拉低状态机跳转信号
                            clk4_cnt <= 'd0;            //计数器清零
                            scl <= 1'b0;
                            i2c_ack <= 1'b0;
                    end
                    default: ;
                endcase
            end

            Write_byte_addr8_state:begin
                case (clk4_cnt)
                    'd0 :begin
                            sda_ctrl<= 1'b1;                //拿回SDA控制权,并且传开始输寄存器地址
                            sda_out <= reg_addr_reg[7];
                    end
                    'd1 :   scl <= 1'b1;
                    'd3 :   scl <= 1'b0;
                    'd4 :   sda_out <= reg_addr_reg[6];
                    'd5 :   scl <= 1'b1;
                    'd7 :   scl <= 1'b0;
                    'd8 :   sda_out <= reg_addr_reg[5];
                    'd9 :   scl <= 1'b1;
                    'd11:   scl <= 1'b0; 
                    'd12:   sda_out <= reg_addr_reg[4];  
                    'd13:   scl <= 1'b1;  
                    'd15:   scl <= 1'b0;  
                    'd16:   sda_out <= reg_addr_reg[3];
                    'd17:   scl <= 1'b1;  
                    'd19:   scl <= 1'b0;  
                    'd20:   sda_out <= reg_addr_reg[2];
                    'd21:   scl <= 1'b1;  
                    'd23:   scl <= 1'b0;  
                    'd24:   sda_out <= reg_addr_reg[1];
                    'd25:   scl <= 1'b1;  
                    'd27:   scl <= 1'b0;  
                    'd28:   sda_out <= reg_addr_reg[0];
                    'd29:   scl <= 1'b1;
                    'd31:   scl <= 1'b0; 
                    'd32:   begin
                            sda_out <= 1'b1;
                            sda_ctrl<= 1'b0;                //释放sda总线 
                    end
                    'd33:   scl <= 1'b1;
                    'd34:   begin
                            state_done <= 1'b1;
                            if(sda_in == 1'b1)
                                i2c_ack <= 1'b0;
                            else
                                i2c_ack <= 1'b1;    
                    end
                    'd35:  begin
                            state_done <= 1'b0;
                            scl <= 1'b0;
                            clk4_cnt <= 'd0;
                            i2c_ack <= 1'b0;
                    end         
                    default: ;
                endcase
            end

            Write_data_state:begin
                case (clk4_cnt)
                    'd0 :begin
                            sda_ctrl<= 1'b1;                //拿回SDA控制权，并且传开始输8位写数据
                            sda_out <= data_reg[7];
                    end
                    'd1 :   scl <= 1'b1;
                    'd3 :   scl <= 1'b0;
                    'd4 :   sda_out <= data_reg[6];
                    'd5 :   scl <= 1'b1;
                    'd7 :   scl <= 1'b0;
                    'd8 :   sda_out <= data_reg[5];
                    'd9 :   scl <= 1'b1;
                    'd11:   scl <= 1'b0; 
                    'd12:   sda_out <= data_reg[4];  
                    'd13:   scl <= 1'b1;  
                    'd15:   scl <= 1'b0;  
                    'd16:   sda_out <= data_reg[3];
                    'd17:   scl <= 1'b1;  
                    'd19:   scl <= 1'b0;  
                    'd20:   sda_out <= data_reg[2];
                    'd21:   scl <= 1'b1;  
                    'd23:   scl <= 1'b0;  
                    'd24:   sda_out <= data_reg[1];
                    'd25:   scl <= 1'b1;  
                    'd27:   scl <= 1'b0;  
                    'd28:   sda_out <= data_reg[0];
                    'd29:   scl <= 1'b1;
                    'd31:   scl <= 1'b0; 
                    'd32:   begin
                            sda_out <= 1'b1;
                            sda_ctrl<= 1'b0;            //释放sda总线 
                    end
                    'd33:   scl <= 1'b1;
                    'd34:   begin
                            state_done <= 1'b1;
                            if(sda_in == 1'b1)
                                i2c_ack <= 1'b0;
                            else
                                i2c_ack <= 1'b1;    
                    end
                   'd35: begin
                             state_done <= 1'b0;
                             scl <= 1'b0;
                             clk4_cnt <= 'd0;
                             i2c_ack <= 1'b0;
                             if (reg_data_index < 4'd6) begin
                                 reg_data_index <= reg_data_index + 1;  // 更新寄存器和数据索引，指向下一个寄存器地址和数据
                                 next_state = Write_slave_addr_state;  // 转到下一个寄存器的写操作
                             end else begin
                                 i2c_done <= 1'b1;  // 标记所有操作完成
                                 next_state = Idle; // 返回到 Idle 状态
                             end
                         end

                    default: ;
                endcase
            end

           
            Stop:begin
                case (clk4_cnt)
                    'd0:    begin
                        sda_ctrl<= 1'b1;
                        sda_out <= 1'b0;
                    end
                    'd1:    scl <= 1'b1;            //在scl为高电平时候，拉高sda代表停止信号
                    'd3:    sda_out <= 1'b1;
                    'd10:   state_done <= 1'b1;
                    'd11:   begin
                             clk4_cnt <= 'd0;
                            // i2c_done <= 1'b1;
                             state_done <= 1'b0;
                    end
                    default: ;
                endcase
            end
            default: ;
        endcase
    end
end

endmodule
