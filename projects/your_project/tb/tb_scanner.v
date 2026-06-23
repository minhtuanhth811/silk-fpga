//bước 1: dựng file, bao dây dẫn
`timescale 1ns / 1ns // đơn vị gốc 1ns, độ phân giải 1ps

module tb_scanner;
    // 1. dây input (phải dùng reg)
    reg clk;
    reg reset;

    // 2. dây output (dùng wire)
    wire hsync;
    wire vsync;
    wire display_on;
    wire [9:0] abs_x;
    wire [9:0] abs_y;


//bước 2: thêm module cần test
    scanner uut(
        .clk(clk),
        .reset(reset),
        .hsync(hsync),
        .vsync(vsync),
        .display_on(display_on),
        .abs_x(abs_x),
        .abs_y(abs_y)
    );


// bước 3: tạo thạch anh ảo
    always #20 clk = ~clk;


// bước 4: tạo kịch bản test
    initial begin
        $dumpfile("scanner.vcd");
        $dumpvars(0, tb_scanner);

        clk = 0;
        reset = 1;

        #100
        reset = 0;

        #17000000;

        $finish;
    end


// bước 5: đặt print giám sát
    always @(posedge clk) begin
        if(abs_x == 0 && abs_y > 0 && abs_y < 5) begin
            $display("Time: %0t ns | Quet xong hang ngang. abs_y dang o dong: %d", $time, abs_y);
        end
    end
endmodule
