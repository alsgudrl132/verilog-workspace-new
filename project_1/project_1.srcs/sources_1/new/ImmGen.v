`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/13/2025 03:30:04 PM
// Design Name: 
// Module Name: ImmGen
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
// Immediate Generator (ImmGen)
// - 명령어에서 즉시값(Immediate value)을 추출하여 32비트로 확장하는 모듈
// - ImmSel 신호에 따라 I, B, U, J, S 타입의 즉시값을 생성
//------------------------------------------------------------

module ImmGen(
    input [2:0] ImmSel,       // 즉시값 종류 선택 신호 (I, B, U, J, S)
    input [24:0] inst_Imm,    // 명령어의 즉시값 비트 부분 (25비트)
    output [31:0] Imm         // 출력: 32비트로 sign-extension된 즉시값
);

    // 각 타입별 즉시값 (Immediate)
    wire [31:0] I, B, U, J, S;

    // I-type: 12비트 즉시값, 부호 확장 (sign-extend)
    // inst_Imm[24]는 부호 비트 → 상위 20비트를 모두 그 값으로 채움
    assign I = {{20{inst_Imm[24]}}, inst_Imm[24 -: 12]};

    // B-type: 분기(branch) 명령용 즉시값
    // 비트 순서가 특이하게 흩어져 있어서 재조합 필요
    assign B = {{19{inst_Imm[24]}}, inst_Imm[24], inst_Imm[0], inst_Imm[23-:6], inst_Imm[4:1]};

    // U-type: 상위 20비트를 그대로 사용하고, 하위 12비트는 0으로 채움
    assign U = {inst_Imm[24 -: 20], 12'b0};
    
    assign J = {{11{inst_Imm[24]}}, inst_Imm[24], inst_Imm[12:5], inst_Imm[13], inst_Imm[23-:10], 1'b0};
    assign S = {{20{inst_Imm[24]}}, inst_Imm[24:7], inst_Imm[4:0]};
    
    assign Imm = (ImmSel == 0) ? I :
                 (ImmSel == 1) ? B :
                 (ImmSel == 2) ? U :
                 (ImmSel == 3) ? J :
                 (ImmSel == 4) ? S : 0;
endmodule
