//#define DEBUG

#include <Nabaztag.h>

#ifdef DEBUG
#define BAUD_RATE 115200
#endif

// ###################### MAIN

void setup() {
#ifdef DEBUG
  Serial.begin(BAUD_RATE);
#endif

  Nabaztag.init(12);
}

void loop() {
#ifdef DEBUG
  while( Nabaztag.log.getSize() > 0 ) Serial.print(Nabaztag.log.get(), BYTE);
#endif

  delay(3000);
  Nabaztag.send(12);
}

