#include <Wire.h>
#include <ByteBuffer.h>

#define BAUD_RATE 115200

#define READ_BUFFER_SIZE 128

#define CMD_OUT 100 // 0 1

#define CMD_INIT 110 // 0 1
#define CMD_INITATE 111 // 1 2 6 0

#define CMD_SLOT 119 // 3
#define CMD_SELECT_TAG 120 // 1 2 E
#define CMD_GET_UID 121 // 1 1 B
#define CMD_COMP 123 // 1 1 F

#define CMD_READ 124 // 1
#define CMD_CLOSE 125 // 0 0

#define CMD_UNKNOWN 126
#define CMD_NEXT 127

ByteBuffer debugBuffer;

byte in[32]; //where we read cmd intput to
uint8_t out[32]; //where we read cmd intput to
int outSize = 0;
volatile boolean sendEnabled = false;


void inCallback(int);
void outCallback();
byte getCommand(int);

// ###################### MAIN

void setup() {
  Serial.begin(BAUD_RATE);

  Wire.begin(80);
  Wire.onReceive(inCallback);
  Wire.onRequest(outCallback);

  debugBuffer.init(READ_BUFFER_SIZE);
}

void loop() {
  if(debugBuffer.getSize() > 0) {
    Serial.print(debugBuffer.get(), BYTE);
  }
  delay(1);
}

// ##################### CALLBACKS

void inCallback(int length) {
  noInterrupts();

  sendEnabled = false;

  for(int i = 0; i < length; i++) {
    byte data = Wire.receive();
    debugBuffer.put(data);
    in[i] = data;
  }

  byte cmd = getCommand(length);
  debugBuffer.put(cmd);
  debugBuffer.put(CMD_NEXT);

  if( cmd == CMD_READ ) sendEnabled = true; //aparently a send is expected after a read
  if( cmd == CMD_INITATE || cmd == CMD_SELECT_TAG ) { //not sure for CMD_SELECT_TAG, but code shows that
    outSize = 2;
    byte tosend[] = { 1, 1 };
    memcpy(out, tosend, outSize);
  }
  if( cmd == CMD_SLOT ) {
    outSize = 19;
    byte tosend[] = { 18, 0, 1,  0, 0, 0, 0, 0, 0, 0, 0, 0x0F, 0, 0, 0, 0, 0, 0, 0 };
    memcpy(out, tosend, outSize);
  }
  if( cmd == CMD_GET_UID ) {
    outSize = 9;
    byte tosend[] = { 0, 0x00, 0x00, 0x00, 0xEE, 0xFF, 0xCA, 0x00, 0x00, }; // inject highscore here
    memcpy(out, tosend, outSize);
  }

  interrupts();
}

void outCallback() {
  //don't disable interrupts here
  if( sendEnabled && outSize > 0 ) {
    Wire.send(out, outSize);
    debugBuffer.put(outSize);
    debugBuffer.put(CMD_OUT);
    debugBuffer.put(CMD_NEXT);
  }
}

// ##################### OTHER

byte getCommand(int length) { //TODO pass 'in' as array pointer here??
  switch( length ) {
    case 4:
      if( in[0] == 1 && in[1] == 2 && in[2] == 0x0E ) return CMD_SELECT_TAG; //forth byte variable
      if( in[0] == 1 && in[1] == 2 && in[2] == 0x06 && in[3] == 0 ) return CMD_INITATE;
      break;
    case 3:
      if( in[0] == 1 && in[1] == 0x01 && in[2] == 0x0F ) return CMD_COMP;
      if( in[0] == 1 && in[1] == 0x01 && in[2] == 0x0B ) return CMD_GET_UID;
      break;
    case 2:
      if( in[0] == 0 && in[1] == 0x10 ) return CMD_INIT;
      if( in[0] == 0 && in[1] == 0x00 ) return CMD_CLOSE;
      break;
    case 1:
      if( in[0] == 3 ) return CMD_SLOT;
      if( in[0] == 1 ) return CMD_READ;
      break;
   }
  return CMD_UNKNOWN;
}

