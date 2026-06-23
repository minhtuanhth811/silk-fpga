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

    initial begin
        // Ghi log ra file để lát xem nó ghi được mấy MB thì nổ ổ cứng
        $dumpfile("suicide_test.vcd"); 
        $dumpvars(0, tb_vga);

        clk = 0;
        rst_n = 1;

        //doi 100_000_000 periods = 1ms, chet ngắc không print Alive..
        //doi 1_000_000 period  = 10ms, được 140ms, print alive 14 lan
        //doi 140ms, rồi doi 100_000 period(1ms) được 193ms(53ms) print alive 52 lần
        #19300000;

        while (1) begin
            #10000
            // Nhổ log ra rạp báo cáo sự sống
            $display("Time: %0t ns | Alive...", $time);
        end

        // Dòng code mang tính nhạo báng: Vĩnh viễn không bao giờ chạy tới
        $display("Dead");
        $finish;
    end

    // initial
    // begin

    //     $dumpfile("tb_vga.vcd");
    //     $dumpvars(0, top_inst.game_over);
    //     $dumpvars(0, top_inst.reset_n);
    //     $dumpvars(0, top_inst.edge_detector);
    //     $dumpvars(0, top_inst.jump_latch);
    //     $dumpvars(0, top_inst.collision_latched);
    //     $dumpvars(0, top_inst.frame_tick);
    //     $dumpvars(0, top_inst.jumping);

    //     clk = 0;
    //     rst_n = 0;
    //     SW = 8'b0;
    //     $display("=== Game start ===");

    //     #3;
    //     rst_n = 1;
    //     SW[0] = 1;

    //     #10;
    //     SW[0] = 0;

    //     force top_inst.cactus_inst.cac_x = 151;
    //     #4;
    //     release top_inst.cactus_inst.cac_x;


    //     wait(top_inst.cactus_inst.cac_x < 150);

    //     $display("Time: %0t ns | Lan 1: Xuong rong den gan, BAM NHAY!", $time);
    //     SW[0] = 1;

    //     #5000;

    //     SW[0] = 0;

    //     wait(top_inst.jumping == 0);
    //     $display("Time: %0t ticks | Khung long da dap dat an toan.", $time);

    //     // --- TELEPORT 2: Bốc xương rồng đặt ngược về bên phải ---
    //     force top_inst.cactus_inst.cac_x = 100;
    //     #4;
    //     release top_inst.cactus_inst.cac_x;



    //     wait(top_inst.game_over == 1);
    //     $display("Time: %0t ms | GAME OVER", $time);
    //     #100;

    //     $display("=== HOAN TAT MO PHONG ===");
    //     $finish;
    // end
endmodule