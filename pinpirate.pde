#include <log.h>

#include <Nabaztag.h>

#ifdef DEBUG
#define BAUD_RATE 115200
#endif

ByteBuffer logBuffer;

int k = 0;

void setup() {
  linit();
  Nabaztag.init(12);
}

void loop() {
  lsend();
  delay(1000);

  if((k % 4) == 0) {

    byte a[] = { 0, k, 0, 0xEE, 0xFF, 0xCA, 0, 0};
    Nabaztag.send(a, 8);

  }
  k++;
}

