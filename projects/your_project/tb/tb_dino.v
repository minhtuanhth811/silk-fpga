`timescale 10ns/10ns

module tb_dino;
    reg clk;
    reg rst_n;
    reg game_over;
    reg command;
    reg [9:0] abs_x;
    reg [9:0] abs_y;
    reg [9:0] prev_y;
    wire draw_dino;
    wire state;
    integer x,y;

    c_dino dino_i (
        .clk(clk),
        .abs_x(abs_x),
        .abs_y(abs_y),
        .rst_n(rst_n),
        .game_over(game_over),
        .draw_dino(draw_dino),
        .state(state),
        .command(command)
    );

    always #2 clk = ~clk;
    
    task pump_frametick;
        begin 
            force dino_i.frame_tick = 1;
            @(posedge clk);
            force dino_i.frame_tick = 0;
            @(posedge clk);
        end
    endtask

    initial begin : TEST
        $dumpfile("tb_dino.vcd");
        $dumpvars(0, rst_n);
        $dumpvars(0, game_over);
        $dumpvars(0, state);
        $dumpvars(0, command);
        $dumpvars(0, dino_i.dino_y_reg);
        $dumpvars(0, dino_i.dino_y_reg);

        clk = 0;
        rst_n = 0;
        game_over = 0;
        command = 0;
        abs_x = 0;
        abs_y = 0;
        
        #4; 
        rst_n = 1;
        $display("Time %0t ns | === START ===", $time);

        #4;
        for(y = 0; y < 40; y = y + 1) begin
            abs_y = dino_i.DINO_START_Y + y;
            for(x = 0; x < 40; x = x + 1) begin
                abs_x = dino_i.DINO_X + x;
                @(posedge clk);
                if(draw_dino) $write("█");
                else $write(" ");
            end
            $write("\n");
        end
        $display("Time %0t ns | === HOAN THANH TEST SPRITE ===", $time);

        #4;
        prev_y = dino_i.dino_y_reg;
        command = 1;
        repeat(5) pump_frametick();
        command = 0;
        repeat(5) pump_frametick();
        if (dino_i.dino_y_reg == prev_y) $display("Time %0t ns | === TEST JUMP FAIL ===", $time);
        else $display("Time %0t ns | === TEST JUMP OK===", $time);
        if (state == 0) $display("Time %0t ns | === TEST STATE FAIL ===", $time);
        else $display("Time %0t ns | === TEST STATE FAIL ===", $time);

        command = 0;
        repeat(30) pump_frametick();
        if (dino_i.dino_y_reg != dino_i.DINO_START_Y) $display("Time %0t ns | === TEST FALL FAIL===", $time);
        else $display("Time %0t ns | === TEST FALL OK===", $time);
        if (state == 0) $display("Time %0t ns | === TEST STATE OK ===", $time);
        else $display("Time %0t ns | === TEST STATE FAIL ===", $time);

        #4;
        command = 1;
        pump_frametick();
        command = 0;
        rst_n = 0;
        pump_frametick();
        rst_n = 1;
        #4;
        if (dino_i.dino_y_reg != dino_i.DINO_START_Y) $display("Time %0t ns | === TEST RESET FAIL===", $time);
        else $display("Time %0t ns | === TEST RESET OK===", $time);

        #4;
        command = 1;
        pump_frametick();
        command = 0;
        pump_frametick();
        game_over = 1;
        @(posedge clk);
        prev_y = dino_i.dino_y_reg;
        repeat(2) pump_frametick();
        if (prev_y == dino_i.dino_y_reg) $display("Time %0t ns | === TEST GAMEOVER OK ===", $time);
        else $display("Time %0t ns | === TEST GAMEOVER FAIL ===", $time);

        $display("Time %0t ns | === HOAN THANH TEST ===", $time);
        $finish;

    end
endmodule 