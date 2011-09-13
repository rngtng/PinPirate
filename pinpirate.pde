#include <Wire.h>

#define BAUD_RATE 115200

#define CHAN0 22
#define CHAN7 29

#define READ_BUFFER_SIZE 1024

volatile byte readBuffer[READ_BUFFER_SIZE];
volatile byte writePointer = 0;
byte readPointer = 0;

void measure(int numBytes) {  
  for(int m = numBytes; m > 0; m--) {
    readBuffer[writePointer] = Wire.receive();
    writePointer++;
    //pointer overflow, reset (guess it's faster than modulo)
    if(writePointer == READ_BUFFER_SIZE) {
      writePointer = 0;
    }
  }
  
  
      readBuffer[writePointer] = 111;
    writePointer++;
    //pointer overflow, reset (guess it's faster than modulo)
    if(writePointer == READ_BUFFER_SIZE) {
      writePointer = 0;
    }
}

int k = 0;

void setup() {
  Serial.begin(BAUD_RATE);
  Wire.begin(80);
  Wire.onReceive(measure);
}

void loop() {

  if(writePointer != readPointer) {
    Serial.print(readBuffer[readPointer]);
    readPointer++;

    //pointer overflow, reset (guess it's faster than modulo)
    if(readPointer == READ_BUFFER_SIZE) {
      readPointer = 0;
    }
  }
  delay(1);
}


