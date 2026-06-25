`timescale 10ns/1ns

module tb_cactus;
    reg clk;
    reg [9:0] abs_x;
    reg [9:0] abs_y;
    reg game_over;
    reg rst_n;
    wire draw_cactus;
    reg [9:0] prev_x;
    integer x,y;

    c_cactus cactus_inst(
        .clk(clk),
        .abs_x(abs_x),
        .abs_y(abs_y),
        .rst_n(rst_n),
        .game_over(game_over),
        .draw_cactus(draw_cactus)
    );
    
    always #2 clk = ~clk;
    initial begin : VONG_LAP_X_QUANG
        $dumpfile("tb_cactus.vcd");
        $dumpvars(0, cactus_inst.cac_x);
        $dumpvars(0, cactus_inst.cac_y);
        $dumpvars(0, cactus_inst.frame_tick);
        $dumpvars(0, rst_n);
        $dumpvars(0, game_over);
        $dumpvars(0, draw_cactus);

        clk = 0;
        abs_x = 0;
        abs_y = 0;
        game_over = 0;
        rst_n = 0;

        #10;
        
        rst_n = 1;


        $display("Time %0t ns | === START ===", $time);
        
        for(y = 0; y < 40; y = y + 1) begin
            abs_y = y + cactus_inst.cac_y;
            for (x = 0; x < 40; x = x + 1) begin
                abs_x = x + cactus_inst.cac_x;
                @(posedge clk);
                if (draw_cactus) $write("█");
                else $write(" ");
            end
            $write("\n");
        end
        $display("\nTime %0t ns | ==============================", $time);
        $display("Time %0t ns | === HOAN THANH TEST SPRITE ===", $time);

        while (cactus_inst.cac_x > 400) begin
            force cactus_inst.frame_tick = 1;
            @(posedge clk);
            force cactus_inst.frame_tick = 0;
            repeat(2) @(posedge clk);
        end
        $display("Time %0t ns | === HOAN THANH TEST CHUYEN DONG ===", $time);

        while (cactus_inst.cac_x < 500 ) begin
            force cactus_inst.frame_tick = 1;
            @(posedge clk);
            force cactus_inst.frame_tick = 0;
            repeat(2) @(posedge clk);
        end
        $display("Time %0t ns | === HOAN THANH TEST QUAY VE ===", $time);

        while (cactus_inst.cac_x > 600 ) begin
            force cactus_inst.frame_tick = 1;
            @(posedge clk);
            force cactus_inst.frame_tick = 0;
            repeat(2) @(posedge clk);
        end

        rst_n = 0;
        while (cactus_inst.cac_x != 640 ) begin
            force cactus_inst.frame_tick = 1;
            @(posedge clk);
            force cactus_inst.frame_tick = 0;
            rst_n = 0;
            repeat(2) @(posedge clk);
        end
        $display("Time %0t ns | === HOAN THANH TEST RESET ===", $time);

        game_over = 1;
        while (cactus_inst.cac_x - prev_x != 0) begin
            force cactus_inst.frame_tick = 1;
            @(posedge clk);
            force cactus_inst.frame_tick = 0;
            game_over = 0;
            prev_x = cactus_inst.cac_x;
            repeat(2) @(posedge clk);
        end
        $display("Time %0t ns | === HOAN THANH TEST GAMEOVER ===", $time);
    end

endmodule