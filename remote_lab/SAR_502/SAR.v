module top(
  output reg [7:0] out,
  input wire clk,
  input wire start,
  input wire refer,
  output reg done
);
  reg [2:0] idx
  always @(posedge clk) begin
    if (!start) begin
      out <= 8'b10000000;
      idx <= 7;
      done <= 0; // done HIGH la hoan thanh
    end
    else if (done == 0)  begin
      //refer = 1 tức là áp tạo từ out lớn hơn ap thuc, cân đua ve 0 đe nho hon
      if (refer == 1) out[idx] <= 1'b0;
      if (idx != 0) begin
        out[idx-1] <= 1'b1;
        idx <= idx - 1;
      end
      else done <= 1;
    end
  end
endmodule
