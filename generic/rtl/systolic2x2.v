module systolic2x2(
    input clk,
    input rst_n,
    input  [3:0] a00,
    input  [3:0] a01,
    input  [3:0] a10,
    input  [3:0] a11,
    input  [3:0] b00,
    input  [3:0] b01,
    input  [3:0] b10,
    input  [3:0] b11,
    output [8:0] c00,
    output [8:0] c01,
    output [8:0] c10,
    output [8:0] c11
  );

  reg [2:0] counter;
  always @(posedge clk)
  begin
    if (!rst_n)
    begin
      counter <= 'b0;
    end
    else
      counter <= counter + 1;
  end

  reg [3:0] n0, n1; //column
  reg [3:0] m0, m1; //row

  always @*
  begin
    case (counter)
      1:
      begin
        n0 = b10;
        m0 = a01;
        n1 = 'b0;
        m1 = 'b0;
      end
      2:
      begin
        n0 = b00;
        m0 = a00;
        n1 = b11;
        m1 = a11;
      end
      3:
      begin
        n0 = 'b0;
        m0 = 'b0;
        n1 = b01;
        m1 = a10;
      end
      default:
      begin
        n0 = 'b0;
        m0 = 'b0;
        n1 = 'b0;
        m1 = 'b0;
      end

    endcase
  end

  wire [3:0] row00;
  wire [3:0] col00;
  wire [3:0] row01;
  wire [3:0] col01;
  wire [3:0] row10;
  wire [3:0] col10;
  wire [3:0] row11;
  wire [3:0] col11;

  pe pe00
     (
       .clk(clk),
       .rst_n(rst_n),
       .a(m0),
       .b(n0),
       .a_p(row00),
       .b_p(col00),
       .c(c00)
     );

  pe pe01
     (
       .clk(clk),
       .rst_n(rst_n),
       .a(row00),
       .b(n1),
       .a_p(row01),
       .b_p(col01),
       .c(c01)
     );

  pe pe10
     (
       .clk(clk),
       .rst_n(rst_n),
       .a(m1),
       .b(col00),
       .a_p(row10),
       .b_p(col10),
       .c(c10)
     );

  pe pe11
     (
       .clk(clk),
       .rst_n(rst_n),
       .a(row10),
       .b(col01),
       .a_p(row11),
       .b_p(col11),
       .c(c11)
     );

endmodule

module pe
  (   input  clk,     // clk
      input  rst_n,   // rst active low
      input  [3:0] a, // 4b
      input  [3:0] b, // 4b
      output reg [3:0] a_p, // a_previous
      output reg [3:0] b_p, // b_previous
      output reg [8:0] c    // 9b accumulate output

  );

  always @(posedge clk)
  begin
    if (!rst_n)
    begin
      a_p <= 'b0;
      b_p <= 'b0;
      c   <= 'b0;
    end
    else
    begin
      a_p <= a;
      b_p <= b;
      c <= c + a * b;
    end
  end

endmodule
