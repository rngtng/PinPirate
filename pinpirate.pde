#include <Wire.h>

#define BAUD_RATE 115200

#define READ_BUFFER_SIZE 128

#define CMD_SLOT 119
#define CMD_SELECT_TAG 120
#define CMD_INIT 121
#define CMD_INITATE 122
#define CMD_COMP 123
#define CMD_READ 124
#define CMD_CLOSE 125


uint8_t sendBuffer[READ_BUFFER_SIZE];
volatile byte sendPointer = 0;

volatile byte serialBuffer[READ_BUFFER_SIZE];
volatile byte serialWPointer = 0;
volatile byte serialRPointer = 0;

volatile byte cmdBuffer[READ_BUFFER_SIZE];
volatile byte cmdPointer = 0;
int toSendPointer = 0;

// #########################################################

void measure(int numBytes) {
  for(int m = 0; m < numBytes; m++) {
    cmdBuffer[m] = Wire.receive();
  }
  detect(numBytes);
}

void sendit() {
  if( sendPointer > 0 ) {
    Wire.send(sendBuffer, sendPointer);
  }
}

// #########################################################

void consume(byte cmd, int sendP) {
  sendPointer = sendP;

  serialBuffer[serialWPointer] = cmd;
  serialWPointer++;
  if(serialWPointer >= READ_BUFFER_SIZE) {
    serialWPointer = 0;
  }
}

void detect(int length) {
  if( length == 4 && cmdBuffer[0] == 1 && cmdBuffer[1] == 2 && cmdBuffer[1] == 14 ) {
    consume(CMD_SELECT_TAG, 0);
  }
  if( length == 4 && cmdBuffer[0] == 1 && cmdBuffer[1] == 2 && cmdBuffer[2] == 6 && cmdBuffer[3] == 0 ) {
    sendBuffer[0] = 1;
    sendBuffer[1] = 1;
    toSendPointer = 2;
    consume(CMD_INITATE, 0);
  }

  if( length == 3 && cmdBuffer[0] == 1 && cmdBuffer[1] == 1 && cmdBuffer[2] == 15 ) {
    consume(CMD_COMP, 0);
  }

  if( length == 2 && cmdBuffer[0] == 0 && cmdBuffer[1] == 16 ) {
    consume(CMD_INIT, 0);
  }
  if( length == 2 && cmdBuffer[0] == 0 && cmdBuffer[1] == 0 ) {
    consume(CMD_CLOSE, 0);
  }

  if( length == 1 && cmdBuffer[0] == 3 ) {
    sendBuffer[0] = 18;
    sendBuffer[1] = 0; // 00000000
    sendBuffer[2] = 1; // 00000001

    sendBuffer[3] = 1;
    sendBuffer[4] = 2;
    sendBuffer[5] = 3;
    sendBuffer[6] = 4;
    sendBuffer[7] = 5;
    sendBuffer[8] = 6;
    sendBuffer[9] = 7;
    sendBuffer[10] = 8;
    sendBuffer[11] = 9;
    sendBuffer[12] = 10;
    sendBuffer[13] = 11;
    sendBuffer[14] = 12;
    sendBuffer[15] = 13;
    sendBuffer[16] = 14;
    sendBuffer[17] = 15;
    sendBuffer[18] = 16;

    toSendPointer = 19;
    consume(CMD_SLOT, 0);
  }

  if( length == 1 && cmdBuffer[0] == 1) {
    consume(CMD_READ, toSendPointer);
    toSendPointer = 0;
  }
}

// #########################################################

void setup() {
  Serial.begin(BAUD_RATE);
  Wire.begin(80);
  Wire.onReceive(measure);
  Wire.onRequest(sendit);
}

int k = 0;

void loop() {
  /* readPointer = cmdPointer;

   if( readPointer > 0) {
   Serial.print(111, BYTE);
   Serial.print(readPointer, BYTE);
   for(int m = 0; m < readPointer; m++) {
   Serial.print(cmdBuffer[m], BYTE);
   }
   cmdPointer = 0;
   }
   */

  if(serialWPointer > serialRPointer) {
    Serial.print(serialBuffer[serialRPointer], BYTE);
    serialRPointer++;
    if(serialRPointer >= READ_BUFFER_SIZE) {
      serialRPointer = 0;
    }
  }
  delay(1);

  k++;
  if( k > 1000) {
    Serial.print(118, BYTE);
    k = 0;
  }
}















