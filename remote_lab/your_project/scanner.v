`default_nettype none
`ifndef SCANNER_H
`define SCANNER_H
  module scanner(
    input wire       clk,
    output reg      hsync,
    output reg      vsync,
    output reg      display_on,
    output reg [9:0] abs_x,
    output reg [9:0] abs_y,
    input wire       rst_n,
  );
    parameter H_DISPLAY = 640; // lượng pixel nhìn thấy được
    parameter H_LEFT_BOR = 48; // số pixel border bên trái
    parameter H_RIGHT_BOR = 16; // số pixel border bên phải
    parameter H_RETRACE = 96;  // xung nhịp cần 
  
    parameter V_DISPLAY = 480;
    parameter V_BOT_BOR = 10;
    parameter V_TOP_BOR = 33;
    parameter V_RETRACE = 2;
  
    
    parameter H_RETRACE_START = H_DISPLAY + H_RIGHT_BOR;
    parameter H_RETRACE_END = H_DISPLAY + H_RIGHT_BOR + H_RETRACE -1;
    parameter H_MAX = H_DISPLAY + H_RIGHT_BOR + H_LEFT_BOR + H_RETRACE - 1;
    parameter V_RETRACE_START = V_DISPLAY + V_BOT_BOR;
    parameter V_RETRACE_END = V_DISPLAY + V_BOT_BOR + V_RETRACE -1;
    parameter V_MAX = V_DISPLAY + V_BOT_BOR + V_TOP_BOR + V_RETRACE - 1;
  
    wire hmax = (abs_x == H_MAX) || rst_n;
    wire vmax = (abs_y == V_MAX) || rst_n;
  
    always @(posedge clk) begin
      hsync <= ~(abs_x >= H_RETRACE_START && abs_x <= H_RETRACE_END);
      if(hmax) abs_x <= 0; else abs_x <= abs_x + 1;
    end
    always @(posedge clk) begin
      vsync <= ~(abs_y >= V_RETRACE_START && abs_y <= V_RETRACE_END);
      if(vmax) abs_y <= 0; else abs_y <= abs_y + 1;
    end
  
    assign display_on = (abs_x < H_DISPLAY) && (abs_y < V_DISPLAY);
  endmodule
`endif
