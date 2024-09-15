module tiny_encryption_algorithm(
     input              clk,        // clock
   input              rst_n,      // asynchronous reset active low 
   input              key_valid,  // 1 = input data stable and valid, 0 = o.w.
   input              ptxt_valid, // 1 = input data stable and valid, 0 = o.w.
   input      [63:0]  ptxt,       // plaintext
   input      [127:0] key,        // key
//    input ,           // # of ROUNDS to perform
   output reg [63:0]  ctxt,       // ciphertext
   output reg         ctxt_ready // 1 = output data stable and valid, 0 o.w.
);

// Variabili
localparam DELTA = 32'h9e3779b9; // key schedule constant 

reg ctxt_ready_temp;
initial begin
    ctxt_ready = 1'b0;
    ctxt = 64'b0;
end

reg [31:0] key0, key1, key2, key3;
reg [31:0] sum=32'b0;

wire [63:0] round_output;
reg [63:0] in;
reg [63:0] out = 64'b0;

integer round = 0;

reg [1:0] star;
localparam s0 = 2'b00;
localparam s1 = 2'b01;
localparam s2 = 2'b10;

always_ff @(posedge clk or negedge rst_n)begin
    if (!rst_n)begin
		 key0 <= 32'b0;
       key1 <= 32'b0;
		 key2 <= 32'b0;
		 key3 <= 32'b0;
		 sum <= 32'b0;
		 in <= 64'b0;
		 round <= 0;
		 ctxt_ready_temp <= 1'b0;
		 out <= 64'b0;
       star <= s0;
    end
    else begin
        case(star)
            s0: begin
                star <= (key_valid && ptxt_valid) ? s1 : s0;
            end
            s1: begin
                    round <= 0;
                    key0 <= key[127:96];
                    key1 <= key[95:64];
                    key2 <= key[63:32];
                    key3 <= key[31:0];
                    sum <= DELTA;
					ctxt_ready_temp <= 1'b0;
					out <= 64'b0;
                    in <= ptxt;
                    star <= s2;
            end
            s2: begin
                in<=round_output;
                sum <= sum+DELTA;
					if (round == 32)begin
						ctxt_ready_temp <= 1'b1;
						out <= in;
						star <= s0;
						end
                    else round <= round + 1;
						
            end
        default: star <= s0;
        endcase
     end
end

always @(ctxt_ready_temp or out) begin
	ctxt = out;
	ctxt_ready = ctxt_ready_temp;
 
end

tea_round tiny_encryption_algorithm_round_i(
.in(in),
.key0(key0),
.key1(key1),
.key2(key2),
.key3(key3),
.sum(sum),
.out(round_output)
);

endmodule

module tea_round(
    input [63:0] in,
input [31:0] key0,
input [31:0] key1,
input [31:0] key2,
input [31:0] key3,
input [31:0] sum,
output [63:0] out
);

wire [31:0] uround_temp, lround_temp;

//key0, key1, in, sum, uround_temp
round uround(
.v0(in[63:32]),
.v1(in[31:0]),
.key0(key0),
.key1(key1),
.sum(sum),
.out(uround_temp)
);

round lround(
    .v0(in[31:0]),
    .v1(uround_temp),
    .key0(key2),
    .key1(key3),
    .sum(sum),
    .out(lround_temp)
);

assign out = {uround_temp, lround_temp};

endmodule

module round(
    input [31:0] v0,
    input [31:0] v1,
    input [31:0] key0,
    input [31:0] key1,
    input [31:0] sum,
    output [31:0] out
);

wire [31:0] v1_shifted_sx;
wire [31:0] v1_shifted_dx;

// v1 shift sx di 4
shift_sx shift_l(
    .in(v1),
    .out(v1_shifted_sx)
);
// v1 shifx dx di 5
shift_dx shift_d (
    .in(v1),
    .out(v1_shifted_dx)
);
wire [31:0] add_tmp_0;
wire [31:0] add_tmp_1;
wire [31:0] add_tmp_2;
// shiftx_sx e key0
add_op add_0(
    .op1(v1_shifted_sx),
    .op2(key0),
    .res(add_tmp_0)
);

// v1 e sum
add_op add_1(
    .op1(v1),
    .op2(sum),
    .res(add_tmp_1)
);

// shift_dx e key1
add_op add_2(
    .op1(v1_shifted_dx),
    .op2(key1),
    .res(add_tmp_2)
);

wire [31:0] xor_tmp;

xor_op xor_(
    .op1(add_tmp_0),
    .op2(add_tmp_1),
    .op3(add_tmp_2),
    .res(xor_tmp)
);

wire[31:0] out_tmp;
// v0 e xor_tmp
add_op add_3(
    .op1(v0),
    .op2(xor_tmp),
    .res(out_tmp)
);

assign out = out_tmp;
endmodule

module shift_sx(
    input [31:0] in,
    output [31:0] out
);

assign out = in << 4;
endmodule

module shift_dx(
    input [31:0] in,
    output [31:0] out
);

assign out = in >>5;
endmodule

module add_op(
    input [31:0] op1,
    input [31:0] op2,
    output [31:0] res
);

assign res = op1 + op2;
endmodule

module xor_op (
    input [31:0] op1,
    input [31:0] op2,
    input [31:0] op3,
    output [31:0] res
);
assign res = op1^op2^op3;
endmodule