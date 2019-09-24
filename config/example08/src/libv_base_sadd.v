//========================================================================
//        author   : masw
//        email    : masw@masw.tech     
//        creattime: 一  8/26 20:32:53 2019
//========================================================================
// 1. 基本加法器，低位对齐的加法，高位扩展符号位。输出位宽也是扩展符号位.
// 2. 当输出位宽小于中间临时数据总位宽时，对输出数据做饱和截位输出
// 3. 在上面的基础上再根据WO的数值截取输出数据位宽。大于和值位宽的就扩展符号位，
//    小于的，则高位限制幅度
// template
// libv_base_sadd #(10, 8, 11) libv_base_sadd_inst(.a(), .b(), .o());
// libv_base_sadd #(10, 8, 11, "REG") libv_base_sadd_inst(.clk(), .rst(), ena(), .a(), .b(), .o());
// libv_base_sadd #(10, 8, 11, "CLK") libv_base_sadd_inst(.clk(), .rst(), ena(), .a(), .b(), .o());
module libv_base_sadd//低位对齐的加法。高位扩展符号位
#(
	parameter WIA = 10,
	parameter WIB = 8,
	parameter WO  = 11,
	parameter REG = "NO"
)(
	input           clk,
	input           rst,//reset at high
	input           ena,
	input [WIA-1:0] a  ,
	input [WIB-1:0] b  ,
	output[WO -1:0] o  
);

localparam WD_SUM = WIA > WIB ? WIA + 1: WIB + 1;

wire [WD_SUM-1:0] sum = {{(WD_SUM-WIA){a[WIA-1]}}, a} + {{(WD_SUM-WIB){b[WIB-1]}}, b};
wire [WO-1:0] sum2;

generate// 求和
	if(WO  >= WD_SUM)
		begin 
		assign  sum2 = {{(WO-WD_SUM){sum[WD_SUM-1]}},sum};
		end
	else 
		begin // 高位限制幅度 
		wire not_overflow = (&sum[WD_SUM-1: WO-1]) | (~|sum[WD_SUM-1:WO-1])  ;//全0或全1就是没有溢出
        assign  sum2= not_overflow ? sum[WO-1:0] : {sum[WD_SUM-1], {(WO-1){!sum[WD_SUM-1]}}}  ;
		end
endgenerate


generate//用寄存器
	if( REG == "NO" )
		begin
		assign o = sum2;
		end
	else
		begin
		reg [WO-1:0] sum_reg;
		always @ (posedge clk or posedge rst)
		if(rst) 
			sum_reg <= {(WO){1'b0}};	
		else if(ena)
			sum_reg <= sum2;	
		assign o = sum_reg;
		end
endgenerate


endmodule

