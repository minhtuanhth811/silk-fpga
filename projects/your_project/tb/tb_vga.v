`timescale  1ms / 100us

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
    
    always #20 clk = ~clk;

    initial
    begin

        $dumpfile("tb_vga.vhd");
        $dumpvars(0, top_inst.game_over);
        $dumpvars(0, top_inst.reset_n);
        $dumpvars(0, top_inst.edge_detector);
        $dumpvars(0, top_inst.jump_latch);
        $dumpvars(0, top_inst.collision_latched);
        $dumpvars(0, top_inst.frame_tick);
        $dumpvars(0, top_inst.jumping);

        clk = 0;
        rst_n = 1;
        $display("=== Game start ===");

        wait(top_inst.cactus_inst.cac_x < 150);

        $display("Time: %0t ms | Lan 1: Xuong rong den gan, BAM NHAY!", $time);
        SW[0] = 1;

        #10

        SW[0] = 0;

        wait(top_inst.cactus_inst.cac_x > 600);
        $display("Time: %0t ms | Lan 2: Xuong rong da quay nguoc lai", $time);

        wait(top_inst.game_over == 1);
        $display("Time: %0t ms | GAME OVER", $time);
        #500

        $display("=== HOAN TAT MO PHONG ===");
        $finish;
    end
endmodule