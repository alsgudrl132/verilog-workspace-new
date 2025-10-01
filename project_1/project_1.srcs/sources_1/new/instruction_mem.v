`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/01/2025 02:14:21 PM
// Design Name: 
// Module Name: instruction_mem
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


module instruction_mem(
    output [31:0] inst,          // 출력: 현재 PC가 가리키는 명령어 (32비트)
    input clk,                   // 입력: 클럭 신호
    input inst_wen,              // 입력: instruction write enable (1이면 쓰기 동작 수행)
    input [31:0] inst_data,      // 입력: 저장할 명령어 데이터 (32비트)
    input [6:0] pc,              // 입력: 현재 프로그램 카운터 (0 ~ 127 범위 가능, 명령어 읽을 주소)
    input [6:0] inst_addr        // 입력: 명령어를 저장할 주소 (0 ~ 127)
);
    
    // 32비트 레지스터(inst_reg)를 128개 만든다.
    // 즉, inst_reg[0] ~ inst_reg[127]까지 존재 (Instruction Memory)
    reg [31:0] inst_reg [0:127];  
    
    // 클럭의 양(+)의 에지에서 동작
    always @(posedge clk) begin
        // inst_wen이 1일 경우: inst_data를 inst_addr 위치에 저장
        if(inst_wen) 
            inst_reg[inst_addr] = inst_data;
    end
    
    // inst 출력은 pc 값에 해당하는 inst_reg의 데이터
    // 즉, 프로그램 카운터가 가리키는 명령어를 읽어서 출력
    assign inst = inst_reg[pc];
    
endmodule

