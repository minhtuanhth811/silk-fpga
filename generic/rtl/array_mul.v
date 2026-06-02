module array_mul_top 
    
    (
    input  wire                 clk,     
    input  wire                 rst_n, 
    input  wire [3:0]      a_in,   
    input  wire [3:0]      b_in,
    output reg  [7:0]    p_out    
);


    reg [3:0] a_reg;
    reg [3:0] b_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_reg <= 0;
            b_reg <= 0;
        end else begin
            a_reg <= a_in;
            b_reg <= b_in;
        end
    end

    
    wire [7:0] p_wire;

    array_mul core_inst (
        .a_in(a_reg),
        .b_in(b_reg),
        .p(p_wire)
    );


    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            p_out <= 0;
        end else begin
            p_out <= p_wire;
        end
    end

endmodule




module array_mul
  (
    input [3:0] a_in,
    input [3:0] b_in,
    output [7:0] p
  );
  wire cin,cout;
  wire [7:0] pp1,pp2,pp3,pp4;
  wire [3:0] c1,c2,c3,c4in,c4out;
  //stage1
  genvar i;
  generate
    for (i = 0; i < 3; i = i + 1)
    begin: create_stage1 // 0 to 2
      //            a         b        cin   sum    cout
      fa fa_s1 (a_in[i]&b_in[1],a_in[i+1]&b_in[0],1'b0,pp1[i+1],c1[i]);
    end
  endgenerate
  //stage 2
  assign pp1[4] = a_in[3] & b_in[1];
  genvar j;
  generate
    for (j = 0; j < 3; j = j + 1)
    begin: create_stage2
      //            a         b   cin      sum    cout
      fa fa_s2 (a_in[j]&b_in[2],pp1[j+2],c1[j],pp2[j+2],c2[j]);
    end
  endgenerate
  //stage 3
  assign pp2[5] = a_in[3] & b_in[2];
  genvar k;
  generate
    for (k = 0; k < 3; k = k + 1)
    begin: create_stage3
      //            a         b   cin      sum    cout
      fa fa_s3 (a_in[k]&b_in[3],pp2[k+3],c2[k],pp3[k+3],c3[k]);
    end
  endgenerate
  //stage 4
  genvar l;
  assign pp3[6] = a_in[3] & b_in[3];
  assign c4in[0] = 1'b0;
  generate
    for (l = 0; l < 3; l = l + 1)
    begin: create_stage4
      if (l < 2) //0to1
        assign c4in[l+1] = c4out[l];
      //         a       b     cin    sum    cout
      fa fa_s4 (c3[l],pp3[l+4],c4in[l],pp4[l+4],c4out[l]);
    end
  endgenerate
  // final product
  assign p = {c4out[2], pp4[6], pp4[5], pp4[4], pp3[3], pp2[2], pp1[1], a_in[0]&b_in[0]};
endmodule

module fa (a,b,cin,sum,cout);
  input a;
  input b;
  input cin;
  output sum;
  output cout;
  wire axorb = a^b;
  assign sum = axorb ^ cin;
  assign cout = a&b | axorb & cin;
endmodule

