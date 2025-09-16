/******************************************************************************
* Copyright (C) 2023 Advanced Micro Devices, Inc. All Rights Reserved.
* SPDX-License-Identifier: MIT
******************************************************************************/

#include <stdint.h>
#include <stdio.h>
#include <sys/_types.h>
#include "platform.h"
#include "xil_printf.h"
#include "xparameters.h"
#include "sleep.h"

#define PWM_ADDR XPAR_MYIP_PWM_0_BASEADDR
volatile unsigned int *pwm_inst = (volatile unsigned int*)PWM_ADDR;

int main()
{
    init_platform();
    
    // UART 출력 테스트 (여러 번 시도)
    for(int i = 0; i < 3; i++) {
        print("Hello World\n\r");
        msleep(100);
    }
    
    print("Successfully ran Hello World application\n\r");
    xil_printf("PWM Test Starting...\n\r");
    
    // PWM 초기값 설정
    pwm_inst[0] = 0;
    uint8_t is_high = 0;
    
    xil_printf("Initial PWM value: %d\n\r", pwm_inst[0]);
    
    while (1) {
        // 방향 전환 체크
        if(pwm_inst[0] >= 255) {
            is_high = 1;
            xil_printf("Reached MAX, going down\n\r");
        }
        else if(pwm_inst[0] == 0) {
            is_high = 0;
            xil_printf("Reached MIN, going up\n\r");
        }
        
        // PWM 값 변경
        if(is_high) {
            pwm_inst[0]--;
        }
        else {
            pwm_inst[0]++;
        }
        
        // 주기적으로 현재 값 출력 (디버깅용)
        static int print_counter = 0;
        if(++print_counter >= 50) {  // 500ms마다 출력
            xil_printf("PWM value: %d\n\r", pwm_inst[0]);
            print_counter = 0;
        }
        
        msleep(10);
    }
    
    cleanup_platform();
    return 0;
}