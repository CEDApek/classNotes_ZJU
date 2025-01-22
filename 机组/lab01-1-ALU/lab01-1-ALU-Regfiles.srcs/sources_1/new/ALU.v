`timescale 1ns / 1ps

module ALU(
    input [31:0] A,
    input [2:0] ALU_operation,
    input [31:0] B,
    output reg [31:0] res,
    output reg zero
);

    always @(*) begin
    case(ALU_operation)
       3'b000: res = A & B; //0
       3'b001: res = A | B; //1   
       3'b010: res = A + B; //2
       3'b110: res = A - B; //6
       3'b111: res = A < B; //7
       3'b100: res = ~ (A | B); //4
       3'b101: res = A >>> B[4:0]; //5
       3'b011: res = A ^ B; //3
    endcase
       
        if (res == 32'b0) begin
            zero <= 1'b1;
        end 
        else begin
            zero <= 1'b0;
        end
    end

endmodule
