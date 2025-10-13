`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/13/2025 11:50:27 AM
// Design Name: 
// Module Name: ALU_2
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


//------------------------------------------------------------
// Arithmetic Logic Unit (ALU_2)
// - 기본적인 산술/논리 연산 수행
// - ALUSel 신호에 따라 어떤 연산을 수행할지 선택
//------------------------------------------------------------

module ALU_2(
    input signed [31:0] A, B,  // ALU 입력 (signed로 선언되어 부호 연산 가능)
    output [31:0] ALU_o,       // ALU 결과 출력
    input [3:0] ALUSel         // ALU 연산 선택 신호 (4비트)
);

    // 각 연산 결과 저장용 wire
    wire signed [31:0] ADD, SUB, SLL, SLT, SLTU, XOR, SRL, SRA, OR, AND;
    
    // 산술 및 논리 연산 정의
    assign ADD  = A + B;       // 덧셈
    assign SUB  = A - B;       // 뺄셈
    assign SLL  = A << B;      // 논리적 왼쪽 시프트
    assign SLT  = A < B;       // signed 비교: A < B → 1
    assign SLTU = A < B;       // unsigned 비교 (지금은 같은 연산)
    assign XOR  = A ^ B;       // XOR
    assign SRL  = A >> B;      // 논리적 오른쪽 시프트
    assign SRA  = A >>> B;     // 산술적 오른쪽 시프트 (부호 유지)
    assign OR   = A | B;       // OR
    assign AND  = A & B;       // AND

    // ALUSel에 따라 결과 선택 (4비트 조합)
    assign ALU_o = (ALUSel == 4'b0000) ? ADD  :   // ADD
                   (ALUSel == 4'b1000) ? SUB  :   // SUB
                   (ALUSel == 4'b0001) ? SLL  :   // Shift Left Logical
                   (ALUSel == 4'b0010) ? SLT  :   // Set Less Than
                   (ALUSel == 4'b0011) ? SLTU :   // Set Less Than Unsigned
                   (ALUSel == 4'b0100) ? XOR  :   // XOR
                   (ALUSel == 4'b0101) ? SRL  :   // Shift Right Logical
                   (ALUSel == 4'b1101) ? SRA  :   // Shift Right Arithmetic
                   (ALUSel == 4'b0110) ? OR   :   // OR
                   (ALUSel == 4'b0111) ? AND  : 0;// AND (default=0)
endmodule