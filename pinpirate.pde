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
#define CHANPIN (PIND >> 2) | (PINB << 6)//pins 2 - 9
#define CHAN0 2
#define CHAN1 3
#define CHAN2 4
#define CHAN3 5
#define CHAN4 6
#define CHAN5 7
#define CHAN6 8
#define CHAN7 9
#endif

#define CLK 13
#define CLKPIN (PINB >> 5) & 0x01

#define BUFFER_SIZE 128

volatile byte logicdata[BUFFER_SIZE];
volatile byte write_pointer = 0;
byte read_pointer = 0;

volatile byte old_clock = 0;
volatile byte new_clock = 0;

void measure()
{
  new_clock = CLKPIN;

  if(old_clock == 0 && new_clock == 1) { //raising clock
    logicdata[write_pointer] = CHANPIN;
    write_pointer++;
    if(write_pointer == BUFFER_SIZE) {
      write_pointer = 0;
    }
  }
  old_clock = new_clock;
}

void setup()
{
  Serial.begin(BAUD_RATE);

  //init pins as INPUT
  for(int pin = 2; pin <= 13; pin++ ) {
    pinMode(pin, INPUT);
  }

  //prepate Timer
  Timer1.initialize(500); // 0.02us period = 50kHz
  Timer1.attachInterrupt(measure);
}



void loop()
{
  if(write_pointer != read_pointer) {
    Serial.print(logicdata[read_pointer], BYTE);
    if(read_pointer == BUFFER_SIZE) {
      read_pointer = 0;
    }
  }
}
