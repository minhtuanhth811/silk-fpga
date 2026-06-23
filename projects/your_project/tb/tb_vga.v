`timescale  10ns / 1ns

module tb_vga;
    reg       clk;
    wire      hsync;
    wire      vsync;
    wire      video_active;
    wire [1:0] r;
    wire [1:0] g;
    wire [1:0] b;
    reg       rst_n;
    reg [7:0] SW;


    top_module top_inst(
        .clk(clk),
        .hsync(hsync),
        .vsync(vsync),
        .video_active(video_active),
        .r(r),
        .g(g),
        .b(b),
        .rst_n(rst_n),
        .SW(SW)
    ); 
    
    always #2 clk = ~clk;

    initial
    begin

        $dumpfile("tb_vga.vcd");
        $dumpvars(0, top_inst.game_over);
        $dumpvars(0, top_inst.reset_n);
        $dumpvars(0, top_inst.edge_detector);
        $dumpvars(0, top_inst.jump_latch);
        $dumpvars(0, top_inst.collision_latched);
        $dumpvars(0, top_inst.frame_tick);
        $dumpvars(0, top_inst.jumping);

        clk = 0;
        rst_n = 0;
        SW = 8'b0;
        $display("=== Game start ===");

        #3;
        rst_n = 1;
        SW[0] = 1;

        #10;
        SW[0] = 0;

        force top_inst.cactus_inst.cac_x = 151;
        #4;
        release top_inst.cactus_inst.cac_x;


        wait(top_inst.cactus_inst.cac_x < 150);

        $display("Time: %0t ns | Lan 1: Xuong rong den gan, BAM NHAY!", $time);
        SW[0] = 1;

        #50000;

        SW[0] = 0;

        wait(top_inst.jumping == 0);
        $display("Time: %0t ticks | Khung long da dap dat an toan.", $time);

        // --- TELEPORT 2: Bốc xương rồng đặt ngược về bên phải ---
        force top_inst.cactus_inst.cac_x = 610;
        #4;
        release top_inst.cactus_inst.cac_x;

        wait(top_inst.cactus_inst.cac_x > 600);
        $display("Time: %0t ns | Lan 2: Xuong rong da quay nguoc lai", $time);

        force top_inst.cactus_inst.cac_x = 101;
        #4;
        release top_inst.cactus_inst.cac_x;

        wait(top_inst.game_over == 1);
        $display("Time: %0t ms | GAME OVER", $time);
        #100;

        $display("=== HOAN TAT MO PHONG ===");
        $finish;
    end
endmodule