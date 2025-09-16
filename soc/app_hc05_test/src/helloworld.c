/******************************************************************************
* UART 송신 예제
* AXI UART Lite를 사용하여 문자열을 송신하는 예제
******************************************************************************/

#include <stdio.h>
#include "platform.h"
#include "xil_printf.h"
#include "xparameters.h"
#include "xuartlite.h"
#include "xil_io.h"

// UART 인스턴스
XUartLite UartLite;

int main()
{
    int Status;
    int Counter = 1;
    char NumberChar;
    
    init_platform();
    
    // UART Lite 초기화
    Status = XUartLite_Initialize(&UartLite, XPAR_AXI_UARTLITE_0_BASEADDR);
    if (Status != XST_SUCCESS) {
        print("UART Lite 초기화 실패\r\n");
        return XST_FAILURE;
    }
    
    print("UART Lite 초기화 성공\r\n");
    print("1부터 9까지 숫자 송신 시작\r\n");
    
    // 1부터 9까지 숫자 송신 (무한 루프)
    while(1) {
        // 숫자를 문자로 변환 ('1' = 49, '2' = 50, ...)
        NumberChar = '0' + Counter;
        
        // 숫자 송신
        XUartLite_Send(&UartLite, (u8*)&NumberChar, 1);
        
        Counter++;
        
        // 1초 대기 (대략적인 지연)
        for(int i = 0; i < 10000000; i++) {
            // 단순 지연 루프
        }
        
        // 카운터가 9를 넘으면 1로 리셋
        if(Counter > 9) {
            Counter = 1;
        }
    }
    
    cleanup_platform();
    return 0;
}

/******************************************************************************
* 추가 UART 송신 함수들
******************************************************************************/

// 단일 문자 송신 함수
void SendChar(char c) {
    XUartLite_Send(&UartLite, (u8*)&c, 1);
}

// 문자열 송신 함수
void SendString(char* str) {
    XUartLite_Send(&UartLite, (u8*)str, strlen(str));
}

// 정수 송신 함수
void SendInteger(int num) {
    char buffer[12]; // 최대 11자리 + null terminator
    sprintf(buffer, "%d", num);
    SendString(buffer);
}

// 16진수 송신 함수
void SendHex(int num) {
    char buffer[12];
    sprintf(buffer, "0x%X", num);
    SendString(buffer);
}

/******************************************************************************
* 사용 예제 (main 함수 대신 사용 가능)
******************************************************************************/
/*
int main_alternative()
{
    init_platform();
    
    // UART 초기화
    XUartLite_Initialize(&UartLite, XPAR_XUARTLITE_0_DEVICE_ID);
    
    // 다양한 데이터 타입 송신 예제
    SendString("=== UART 송신 테스트 ===\r\n");
    
    SendString("문자: ");
    SendChar('A');
    SendString("\r\n");
    
    SendString("정수: ");
    SendInteger(12345);
    SendString("\r\n");
    
    SendString("16진수: ");
    SendHex(255);
    SendString("\r\n");
    
    SendString("완료!\r\n");
    
    cleanup_platform();
    return 0;
}
*/