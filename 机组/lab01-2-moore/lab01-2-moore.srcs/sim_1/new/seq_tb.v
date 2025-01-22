`timescale 1ns / 1ps
module tb_seq();
    reg clk;
    reg reset;
    reg in;
    wire out;

    // Generate clock with a period of 40 time units
    always #20 clk = ~clk;

    // Initial block to initialize signals
    initial begin
        clk = 0;
        reset = 0;
        #20 reset = 1;   // Apply reset after 20 time units
    end
    // Stimulus block to drive input signals
    // The sequence of inputs represents 011100101
    initial begin
        in = 0;
        #30 in = 1;      // 0 after 30 time units
        #40 in = 1;      // 1 after 40 more time units
        #40 in = 1;      // 1 after another 40 time units
        #40 in = 0;      // 0 after another 40 time units
        #40 in = 0;      // 0 after another 40 time units
        #40 in = 1;      // 1 after another 40 time units
        #40 in = 0;      // 0 after another 40 time units
        #40 in = 1;      // 1 after another 40 time units
        #40 $finish;     // End the simulation after the last input
    end

    // Instantiate the sequence detector module
    seq seq_u1(
        .clk (clk),
        .reset (reset),
        .in (in),
        .out (out)
    );
endmodule

