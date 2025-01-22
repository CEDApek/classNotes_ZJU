module Regs_tb;
    reg clk;
    reg rst;
    reg [4:0] Rs1_addr; 
    reg [4:0] Rs2_addr; 
    reg [4:0] Wt_addr; 
    reg [31:0] Wt_data; 
    reg RegWrite; 
    wire [31:0] Rs1_data; 
    wire [31:0] Rs2_data;

    // Instantiate the Regs module
    Regs Regs(
        .clk(clk),
        .rst(rst),
        .Rs1_addr(Rs1_addr),
        .Rs2_addr(Rs2_addr),
        .Wt_addr(Wt_addr),
        .Wt_data(Wt_data),
        .RegWrite(RegWrite),
        .Rs1_data(Rs1_data),
        .Rs2_data(Rs2_data)
    );

    // Clock generation
    always #10 clk = ~clk;

    // Testbench initial block
    initial begin
        // Initialize signals
        clk = 0;
        rst = 1;
        RegWrite = 0;
        Wt_data = 0;
        Wt_addr = 0;
        Rs1_addr = 0;
        Rs2_addr = 0;

        // 0ns-100ns: regfile初始化复位，读写都为0
        #100 rst = 0;

        // 100ns-150ns: RegWrite=1; Wt_addr[4:0]=05; Wt_data[31:0]=a5a5a5a5; 写地址05
        RegWrite = 1;
        Wt_addr = 5'b00101; // 05
        Wt_data = 32'ha5a5a5a5;

        // 150ns-200ns: RegWrite=1; Wt_addr[4:0]=0a; Wt_data[31:0]=5a5a5a5a; 写地址0a
        #50 Wt_addr = 5'b01010; // 0a
        Wt_data = 32'h5a5a5a5a;

        // 200ns-300ns: RegWrite=0; Rs1_addr[4:0]=05; Rs1_data[31:0]=a5a5a5a5; 读地址05
        // 200ns-300ns: RegWrite=0; Rs2_addr[4:0]=0a; Rs2_data[31:0]=5a5a5a5a; 读地址0a
        #50 RegWrite = 0;
        Rs1_addr = 5'b00101; // 05
        Rs2_addr = 5'b01010; // 0a

        // Extend simulation time for better observation
        #100 $stop();
    end

endmodule