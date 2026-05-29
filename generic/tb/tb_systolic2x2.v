`timescale 1ns/1ps

module tb_systolic2x2;
    // Clock and Reset signals
    reg clk;
    reg rst_n;

    // Input ports (4-bit)
    reg [3:0] a00, a01, a10, a11;
    reg [3:0] b00, b01, b10, b11;

    // Output ports (9-bit to prevent overflow)
    wire [8:0] c00, c01, c10, c11;

    // Instantiate the Device Under Test (DUT)
    systolic2x2 dut (
        .clk(clk),
        .rst_n(rst_n),
        .a00(a00), .a01(a01), .a10(a10), .a11(a11),
        .b00(b00), .b01(b01), .b10(b10), .b11(b11),
        .c00(c00), .c01(c01), .c10(c10), .c11(c11)
    );

    // Generate 100MHz clock (10ns period)
    // Clock edges will be at 5ns, 15ns, 25ns... (posedge)
    // and 10ns, 20ns, 30ns... (negedge)
    initial clk = 0;
    always #5 clk = ~clk;

    // Stimulus process
    initial begin
        // Dump variables for waveform viewing (Ideal for GTKWave on Ubuntu)
        $dumpfile("sim/waveform.vcd");
        $dumpvars(0, tb_systolic2x2);

        // 1. Assert Reset
        rst_n = 0;
        
        // Initialize all inputs to 0 to avoid 'X' states
        {a00, a01, a10, a11} = 16'h0;
        {b00, b01, b10, b11} = 16'h0;
        
        // Wait for 1.5 clock cycles, then deassert reset at posedge (t = 15ns)
        #15; 
        rst_n = 1;
        
        // 2. Wait for the next negative edge to safely apply data
        // This occurs at t = 20ns. The data will be perfectly stable 
        // before the next posedge at t = 25ns (where counter increments to 1).
        @(negedge clk);
        
        // Apply Custom Test Case
        // Matrix A:       Matrix B:
        // [1  2]          [1  3]
        // [2  3]          [1  2]
        
        // Load Matrix A
        a00 = 4'd1; a01 = 4'd2;
        a10 = 4'd2; a11 = 4'd3;

        // Load Matrix B
        b00 = 4'd1; b01 = 4'd3;
        b10 = 4'd1; b11 = 4'd2;

        // 3. Wait for data to propagate through pipeline registers
        // Give it 6 clock cycles (60ns) to ensure all MAC operations complete
        #60;
        
        // 4. Display Results
        $display("----------------------------------------");
        $display("Time: %0t | Negedge Data Push Test Results:", $time);
        $display("Matrix C = A * B");
        $display("Calculated C = [%d  %d]", c00, c01);
        $display("               [%d  %d]", c10, c11);
        $display("Expected   C = [3   7]");
        $display("               [5  12]");
        
        // Self-checking logic
        if (c00 == 9'd3 && c01 == 9'd7 && c10 == 9'd5 && c11 == 9'd12) begin
            $display("Status: PASSED");
        end else begin
            $display("Status: FAILED - Output does not match expected values.");
        end
        $display("----------------------------------------");

        // End simulation
        #20;
        $finish;
    end
endmodule
