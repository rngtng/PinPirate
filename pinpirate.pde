#include <TimerOne.h>

#define BAUD_RATE 115200


#if defined(__AVR_ATmega1280__) || defined(__AVR_ATmega2560__)
#define CHANPIN PINA //pins 22 - 29
#define CHAN0 22
#define CHAN1 23
#define CHAN2 24
#define CHAN3 25
#define CHAN4 26
#define CHAN5 27
#define CHAN6 28
#define CHAN7 29
#else
//PIND: 2-7, PINB: 8-13 - non of them are 8bit, so we have to read both and merge
#define READ_CHAN1  (PIND >> 2) & 0x0F //pins 2 - 5
#define READ_CHAN2 PINB & 0x0F //pins 8 - 11
#define CHAN0 2
#define CHAN1 3
#define CHAN2 4
#define CHAN3 5
#define CHAN4 8
#define CHAN5 9
#define CHAN6 10
#define CHAN7 11
#define CLK 7
#define READ_CLK (PIND >> 4) & 0x01
#endif


#define READ_BUFFER_SIZE 128

volatile byte readBuffer[READ_BUFFER_SIZE];
volatile byte writePointer = 0;
byte readPointer = 0;

volatile byte commandBuffer[READ_BUFFER_SIZE];

volatile byte prevClock = 0;
volatile byte clock = 0;

int k;
volatile int l;

void measure() {
  clock = READ_CLK;

  if(prevClock == 0 && clock == 1) { //raising clock
    readBuffer[writePointer] = READ_CHAN1;
    writePointer++;
    //pointer overflow, reset (guess it's faster than modulo)
    if(writePointer == READ_BUFFER_SIZE) {
      writePointer = 0;
    }

    readBuffer[writePointer] = READ_CHAN2;
    writePointer++;
    //pointer overflow, reset (guess it's faster than modulo)
    if(writePointer == READ_BUFFER_SIZE) {
      writePointer = 0;
    }
  }
  prevClock = clock;
}

void setup() {
  Serial.begin(BAUD_RATE);

  //init pins as INPUT
  for(int pin = 2; pin <= 13; pin++ ) {
    pinMode(pin, INPUT);
  }

  //prepate Timer
  Timer1.initialize(20); // 0.02us period = 50kHz
  Timer1.attachInterrupt(measure);
}

void loop() {

  if(writePointer != readPointer) {
    Serial.print(readBuffer[readPointer], BYTE);
    readPointer++;

    //pointer overflow, reset (guess it's faster than modulo)
    if(readPointer == READ_BUFFER_SIZE) {
      readPointer = 0;
    }
  }
  delay(1);
}
