`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/13/2025 12:24:10 PM
// Design Name: 
// Module Name: control
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
// Control Unit (control)
// - 명령어(instruction)를 해석하여 ALUSel, ImmSel 등 제어 신호 생성
// - 명령어의 opcode를 부분적으로 해석해서 유형을 구분
//------------------------------------------------------------

module control(
    input [31:0] instruction,  // 전체 명령어 입력
    output [3:0] ALUSel,       // ALU 연산 선택 신호
    output [2:0] ImmSel,        // 즉시값 선택 신호 (I=0, B=1, U=2, J=3, S=4)
    output [2:0] WordSizeSel,   // Byte : 0, Half Word : 1, Word : 2,
    output BSel, MemRW, WBSel 
);

    // 명령어 종류 판별용 조건 플래그
    wire I_cond, B_cond, U_cond, J_cond, S_cond, R_cond;
    
    // instruction[6:2] : opcode 일부
    // instruction[14:12] : funct3
    // instruction[30] : funct7의 비트
    // → 총 9비트로 묶어서 간소화된 opcode 패턴 생성
    wire [8:0] inst_opcode = {instruction[30], instruction[14:12], instruction[6:2]};
    
    // 각각의 명령어 타입 조건 설정
    assign I_cond = {inst_opcode[4:3], inst_opcode[1:0]} == 4'b0000; // I-type
    assign B_cond = inst_opcode[4:0] == 5'b11000;                    // B-type
    assign U_cond = {inst_opcode[4], inst_opcode[2:0]} == 4'b0101;   // U-type
    assign J_cond = inst_opcode[4:0] == 5'b11011;                    // J-type
    assign S_cond = inst_opcode[4:0] == 5'b01000;                    // S-type
    assign R_cond = inst_opcode[4:0] == 5'b01100;                    // R-type

    assign BSel = R_cond;
    assign MemRW = S_cond;
    
    // ALU 제어 신호는 funct7[5:0] 기반 (상위 4비트만 추출)
    assign ALUSel = inst_opcode[8:5];
    
    // 즉시값 선택 (ImmSel)
    assign ImmSel = (I_cond == 1) ? 0 :
                    (B_cond == 1) ? 1 :
                    (U_cond == 1) ? 2 :
                    (J_cond == 1) ? 3 :
                    (S_cond == 1) ? 4 : 5; // 기본값 5 (잘못된 타입)
                    
    assign WBSel = (inst_opcode[4:0] == 5'b00000) ? 0 : 1;        
    
    assign WordSizeSel = inst_opcode[7:5];
         
endmodule
