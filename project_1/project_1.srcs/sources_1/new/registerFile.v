`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/13/2025 11:35:18 AM
// Design Name: 
// Module Name: registerFile
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


//---------------------------------------------------------------
// 32-bit Register File (레지스터 파일)
// - 총 32개의 32비트 레지스터를 보유
// - 두 개의 레지스터를 동시에 읽고, 하나를 쓸 수 있음
// - 동기식 리셋 및 쓰기 동작 지원
//---------------------------------------------------------------

module registerFile(
    output [31:0] RD1, RD2,   // RD1(Read Data 1), RD2(Read Data 2)
                              // -> 읽어온 두 개의 레지스터 데이터 출력
    input [31:0] WD,          // WD(Write Data)
                              // -> WR이 가리키는 레지스터에 쓸 데이터
    input [4:0] RR1, RR2, WR, // RR1(Read Register 1), RR2(Read Register 2)
                              // WR(Write Register)
                              // -> 각각 읽거나 쓸 레지스터의 인덱스 (0~31)
    input RegWrite,           // RegWrite(Register Write Enable)
                              // -> 1이면 WR 위치에 WD를 저장
    input clk, reset_p        // clk(클록), reset_p(리셋 신호, 양의 엣지에서 동작)
);

//---------------------------------------------------------------
// 레지스터 파일 선언
// - 32개의 32비트 레지스터로 구성
//---------------------------------------------------------------
reg [31:0] Register_file [0:31];

//---------------------------------------------------------------
// 레지스터 읽기(Read)
// - 조합 논리(combinational logic)
// - RR1, RR2에 해당하는 값 즉시 출력
//---------------------------------------------------------------
assign RD1 = Register_file[RR1];
assign RD2 = Register_file[RR2];

//---------------------------------------------------------------
// 레지스터 쓰기(Write) 및 리셋 처리
// - 클록의 양의 엣지에서 동작 (posedge clk)
//---------------------------------------------------------------
always @(posedge clk) begin
    // 리셋 신호가 들어오면 모든 레지스터를 0으로 초기화
    if (reset_p) begin
        Register_file[0]  = 0;
        Register_file[1]  = 0;
        Register_file[2]  = 0;
        Register_file[3]  = 0;
        Register_file[4]  = 0;
        Register_file[5]  = 0;
        Register_file[6]  = 0;
        Register_file[7]  = 0;
        Register_file[8]  = 0;
        Register_file[9]  = 0;
        Register_file[10] = 0;
        Register_file[11] = 0;
        Register_file[12] = 0;
        Register_file[13] = 0;
        Register_file[14] = 0;
        Register_file[15] = 0;
        Register_file[16] = 0;
        Register_file[17] = 0;
        Register_file[18] = 0;
        Register_file[19] = 0;
        Register_file[20] = 0;
        Register_file[21] = 0;
        Register_file[22] = 0;
        Register_file[23] = 0;
        Register_file[24] = 0;
        Register_file[25] = 0;
        Register_file[26] = 0;
        Register_file[27] = 0;
        Register_file[28] = 0;
        Register_file[29] = 0;
        Register_file[30] = 0;
        Register_file[31] = 0;
    end
    // 리셋이 아닐 때, RegWrite 신호가 1이면 쓰기 수행
    else if (RegWrite) begin
        // WR이 0이면(=x0 레지스터) 쓰기 금지 — RISC-V 등에서 x0은 항상 0
        if (WR) Register_file[WR] = WD;
    end
end

endmodule
