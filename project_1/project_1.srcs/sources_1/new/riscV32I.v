`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/14/2025 12:18:52 PM
// Design Name: 
// Module Name: riscV32I
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module riscV32I(
    input clk, reset_p
    );
    
    reg [6:0] PC;
    wire [6:0] PC_NEXT;
    
    assign PC_NEXT = PC + 1;
    
    always @(posedge clk, posedge reset_p) begin
        if(reset_p)PC = 0;
        else begin
            PC = PC_NEXT;
        end
    end
    
    wire [31:0] instruction;
    
    instr_mem IMEM(.instruction(instruction), .PC(PC));
    
    wire [31:0] DataA, DataB;
    wire [31:0] WB; // Write Back
    wire RegEn;
    
    registerFile REGFILE(.RD1(DataA), .RD2(DataB), .WD(WB), .RR1(instruction[19:15]), .RR2(instruction[24:20]), .WR(instruction[11:7]),
                         .RegWrite(RegEn), .clk(clk), .reset_p(reset_p));
                  
    wire [31:0] A, B, ALU_o;                 
    wire [3:0] ALUSel;
    ALU_2 ALU(.A(A), .B(B), .ALU_o(ALU_o), .ALUSel(ALUSel));   
    
    wire [2:0] ImmSel;
    control CNTR(.instruction(instruction), .ALUSel(ALUSel), .ImmSel(ImmSel));               
endmodule
