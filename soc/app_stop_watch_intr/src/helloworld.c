/******************************************************************************
* helloworld.c - 간단 스톱워치/랩타임 LCD 출력 예제
******************************************************************************/

#include <stdint.h>
#include "xiic.h"
#include <stdio.h>
#include <xil_printf.h>
#include "platform.h"
#include "xparameters.h"
#include "xgpio.h"
#include "xintc.h"
#include "xil_exception.h"
#include "sleep.h"

// 하드웨어 주소
#define BTN_ADDR XPAR_XGPIO_0_BASEADDR
#define IIC2_ADDR XPAR_AXI_IIC_0_BASEADDR
#define STOP_WATCH_ADDR XPAR_MYIP_STOPWATCH_0_BASEADDR
#define INTC_ADDR   XPAR_XINTC_0_BASEADDR
#define BTN_VECT_ID XPAR_FABRIC_AXI_GPIO_0_INTR
#define BTN_CHANNEL 1

uint32_t prev_btn_state = 0;
int is_running = 0;   

// 랩 타임 변수
int lap_time_sec = 0;
int lap_time_csec = 0;
int lap_time_min = 0;
uint32_t lap_cnt = 0;

// LCD 명령 전송
void lcdCommand(uint8_t command)
{
    uint8_t high_nibble = command & 0xf0;
    uint8_t low_nibble = (command << 4) & 0xf0;
    uint8_t i2c_buffer[4];

    i2c_buffer[0] = high_nibble | 0x04 | 0x08; // EN=1, RS=0
    i2c_buffer[1] = high_nibble | 0x00 | 0x08; // EN=0
    i2c_buffer[2] = low_nibble | 0x04 | 0x08;  // EN=1
    i2c_buffer[3] = low_nibble | 0x00 | 0x08;  // EN=0
    XIic_Send(IIC2_ADDR, 0x27, i2c_buffer, 4, XIIC_STOP);
}

// LCD 데이터 전송
void lcdData(uint8_t data)
{
    uint8_t high_nibble = data & 0xf0;
    uint8_t low_nibble = (data << 4) & 0xf0;
    uint8_t i2c_buffer[4];

    i2c_buffer[0] = high_nibble | 0x05 | 0x08; // EN=1, RS=1
    i2c_buffer[1] = high_nibble | 0x01 | 0x08; // EN=0
    i2c_buffer[2] = low_nibble | 0x05 | 0x08;  // EN=1
    i2c_buffer[3] = low_nibble | 0x01 | 0x08;  // EN=0
    XIic_Send(IIC2_ADDR, 0x27, i2c_buffer, 4, XIIC_STOP);
}

// LCD 초기화
void lcdInit()
{
    msleep(50);
    lcdCommand(0x33);
    msleep(5);
    lcdCommand(0x32);
    msleep(5);
    lcdCommand(0x28); // 4-bit, 2줄
    msleep(5);
    lcdCommand(0x0C); // 디스플레이 ON
    msleep(5);
    lcdCommand(0x06); // 커서 이동 설정
    msleep(5);
    lcdCommand(0x01); // 클리어
    msleep(2);
}

// 문자열 출력
void lcdString(char *str)
{
    while (*str) lcdData(*str++);
}

// 커서 이동
void moveCursor(uint8_t row, uint8_t col)
{
    lcdCommand(0x80 | row << 6 | col);
}

// 초기 LCD 표시 (임시)
void lcdStart(int humi, int temp)
{
    char humiStr[20], tempStr[20];
    sprintf(humiStr, "sec:%d", humi);
    sprintf(tempStr, "csec:%d", temp);
    lcdInit();
    moveCursor(0, 0); lcdString(humiStr);
    moveCursor(1, 0); lcdString(tempStr);
    sleep(1);
}

XGpio btn_instance;
XIntc intc_instance;
void btn_isr(void *CallBackRef);

int main()
{
    init_platform();
    volatile unsigned int* stopwatch_instance = (volatile unsigned int*) STOP_WATCH_ADDR;

    // GPIO, 인터럽트 초기화
    XGpio_Initialize(&btn_instance, BTN_ADDR);
    XIntc_Initialize(&intc_instance, INTC_ADDR);
    XGpio_SetDataDirection(&btn_instance, BTN_CHANNEL, 0b1111);

    XIic iic_instance;
    XIic_Initialize(&iic_instance, IIC2_ADDR);

    XIntc_Connect(&intc_instance, BTN_VECT_ID, (XInterruptHandler)btn_isr, &btn_instance);
    XIntc_Enable(&intc_instance, BTN_VECT_ID);
    XIntc_Start(&intc_instance, XIN_REAL_MODE);

    XGpio_InterruptEnable(&btn_instance, BTN_CHANNEL);
    XGpio_InterruptGlobalEnable(&btn_instance);

    Xil_ExceptionInit();
    Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT,
                                 (Xil_ExceptionHandler)XIntc_InterruptHandler,
                                 &intc_instance);
    Xil_ExceptionEnable();

    lcdInit();
    lcdString("00:00");

    while (1) {
        stopwatch_instance[0] = is_running;

        // 현재 시간 LCD 표시
        moveCursor(0, 0);
        lcdData(stopwatch_instance[5] / 10 % 10 + '0');
        lcdData(stopwatch_instance[5] % 10 + '0');
        lcdData(':');
        lcdData(stopwatch_instance[1] / 10 % 10 + '0');
        lcdData(stopwatch_instance[1] % 10 + '0');
        lcdData(':');
        lcdData(stopwatch_instance[2] / 10 % 10 + '0');
        lcdData(stopwatch_instance[2] % 10 + '0');

        // 랩타임 LCD 표시
        if (lap_cnt == 0 && (lap_time_sec || lap_time_csec || lap_time_min)) {
            moveCursor(1, 0);
            lcdData(lap_time_min / 10 % 10 + '0');
            lcdData(lap_time_min % 10 + '0');
            lcdData(':');
            lcdData(lap_time_sec / 10 % 10 + '0');
            lcdData(lap_time_sec % 10 + '0');
            lcdData(':');
            lcdData(lap_time_csec / 10 % 10 + '0');
            lcdData(lap_time_csec % 10 + '0');
        }
        else if (lap_cnt == 1 && (lap_time_sec || lap_time_csec || lap_time_min)) {
            moveCursor(1, 8);
            lcdData(lap_time_min / 10 % 10 + '0');
            lcdData(lap_time_min % 10 + '0');
            lcdData(':');
            lcdData(lap_time_sec / 10 % 10 + '0');
            lcdData(lap_time_sec % 10 + '0');
            lcdData(':');
            lcdData(lap_time_csec / 10 % 10 + '0');
            lcdData(lap_time_csec % 10 + '0');
        }
    }

    cleanup_platform();
    return 0;
}

// 버튼 ISR
void btn_isr(void *CallBackRef) {
    volatile unsigned int* stopwatch_instance = (volatile unsigned int*) STOP_WATCH_ADDR;
    XGpio *Gpio_ptr = (XGpio *)CallBackRef;
    unsigned int btn_data = XGpio_DiscreteRead(Gpio_ptr, BTN_CHANNEL);

    btn_data = XGpio_DiscreteRead(&btn_instance, BTN_CHANNEL); 

    if (btn_data != 0 && prev_btn_state == 0) {
        switch (btn_data) {
            case 1:  // 스타트/스탑
                is_running = !is_running;
                break;
            case 2:  // 랩 버튼
                stopwatch_instance[0] = 2;
                msleep(10);
                stopwatch_instance[0] = 0;
                lap_time_sec = stopwatch_instance[1];
                lap_time_csec = stopwatch_instance[2];
                lap_time_min = stopwatch_instance[6];
                lap_cnt = (lap_cnt + 1) % 2;
                break;
            case 4:  // 리셋
                stopwatch_instance[0] = 4;
                msleep(10);
                stopwatch_instance[0] = 0;
                lap_time_sec = lap_time_csec = lap_time_min = is_running = lap_cnt = 0;
                moveCursor(0, 0); lcdString("00:00");
                moveCursor(1, 0); lcdString("        ");
                moveCursor(1, 8); lcdString("        ");
                break;
            case 8:  // 미사용
                break;
        }
        msleep(1); // 디바운싱
    }
    prev_btn_state = btn_data;
    msleep(1);
    XGpio_InterruptClear(Gpio_ptr, BTN_CHANNEL);
}
