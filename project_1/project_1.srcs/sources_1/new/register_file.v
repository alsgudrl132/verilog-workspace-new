`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/01/2025 02:37:13 PM
// Design Name: 
// Module Name: register_file
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


module register_file(
    output [31:0] RD1, RD2,   // RD1(Read Data 1), RD2(Read Data 2): 읽은 데이터 값 (32비트)
    input [4:0] RR1, RR2, WR, // RR1(Read Register 1), RR2(Read Register 2): 읽을 레지스터 주소
                              // WR(Write Register): 쓸 레지스터 주소
    input [31:0] WD,          // WD(Write Data): 쓰기 데이터
    input RegWrite, clk, rst  // RegWrite(Register Write Enable): 레지스터 쓰기 허용 신호
                              // clk: 클럭, rst: 리셋
);
    
    // 32비트 레지스터 32개 생성 (Register_file[0] ~ Register_file[31])
    reg [31:0] Register_file [0:31];
    
    // 비동기 읽기 (read): RR1, RR2 주소에 해당하는 값 즉시 출력
    assign RD1 = Register_file[RR1];
    assign RD2 = Register_file[RR2];
    
    // 클럭 상승 에지에서 동작
    always @(posedge clk) begin
        if(rst) begin
            // 리셋 시 모든 레지스터를 0으로 초기화
            Register_file [0] = 0;
            Register_file [1] = 0;
            Register_file [2] = 0;
            Register_file [3] = 0;
            Register_file [4] = 0;
            Register_file [5] = 0;
            Register_file [6] = 0;
            Register_file [7] = 0;
            Register_file [8] = 0;
            Register_file [9] = 0;
            Register_file [10] = 0;
            Register_file [11] = 0;
            Register_file [12] = 0;
            Register_file [13] = 0;
            Register_file [14] = 0;
            Register_file [15] = 0;
            Register_file [16] = 0;
            Register_file [17] = 0;
            Register_file [18] = 0;
            Register_file [19] = 0;
            Register_file [20] = 0;
            Register_file [21] = 0;
            Register_file [22] = 0;
            Register_file [23] = 0;
            Register_file [24] = 0;
            Register_file [25] = 0;
            Register_file [26] = 0;
            Register_file [27] = 0;
            Register_file [28] = 0;
            Register_file [29] = 0;
            Register_file [30] = 0;
            Register_file [31] = 0;
        end
        else if(RegWrite) begin
            // 쓰기 신호가 활성화된 경우
            // WR ≠ 0일 때만 WD를 Register_file[WR]에 저장
            // (x0 레지스터는 항상 0을 유지하기 위함: RISC-V 규칙)
            if(WR) 
                Register_file[WR] = WD;
        end
    end
    
endmodule

