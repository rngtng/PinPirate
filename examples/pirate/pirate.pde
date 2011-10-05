/*
   pirate.pde - Example usage of PinPirate Arduino Library
   Copyright (c) 2011 Tobias Bielohlawek.  All right reserved.
*/

#include <PinPirate.h>

int cnt = 0;

void toBuffer(byte buffer, int length) {
}

void setup() {
  PinPirate.init(); //DATALINES CLK STATUS
  PinPirate.attachInterrupt(toBuffer);
}



void loop() {
  delay(1000);
  // sth in buffer send to stdout

}
