/*
   Nabaztag.cpp -  Inject RFID library for Arduino & Wiring
   Copyright (c) 2011 Tobias Bielohlawek.  All right reserved.

  This library is free software; you can redistribute it and/or
  modify it under the terms of the GNU Lesser General Public
  License as published by the Free Software Foundation; either
  version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
  Lesser General Public License for more details.

  You should have received a copy of the GNU Lesser General Public
  License along with this library; if not, write to the Free Software
  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
*/

#include <Nabaztag.h>
#include <Wire.h>

void receiveCallback(int length)
{
  Nabaztag.processReceive(length);
}

void requestCallback()
{
  Nabaztag.processRequest();
}

#ifdef DEBUG
  ByteBuffer NabaztagInjector::log;
#endif

byte NabaztagInjector::in[32];
uint8_t NabaztagInjector::out[32];
int NabaztagInjector::outSize = 0;
volatile boolean NabaztagInjector::sendEnabled = false;


// Constructors ////////////////////////////////////////////////////////////////

NabaztagInjector::NabaztagInjector()
{
}

// Public //////////////////////////////////////////////////////

void NabaztagInjector::init(int rfidPort)
{
  Wire.begin(CRX14_ADR);
  Wire.onReceive(receiveCallback);
  Wire.onRequest(requestCallback);

#ifdef DEBUG
  log.init(LOG_SIZE);
#endif

}


void NabaztagInjector::send(uint8_t* data, uint8_t quantity)
{
  //TODO
}

void NabaztagInjector::send(uint8_t data)
{
  send(&data, 1);
}

void NabaztagInjector::send(char* data)
{
  send((uint8_t*)data, strlen(data));
}


void NabaztagInjector::send(int data)
{
  send((uint8_t)data);
}

// Callbacks //////////////////////////////////////////////////////

void NabaztagInjector::processReceive(int length) {
  noInterrupts();

  sendEnabled = false;

  for(int i = 0; i < length; i++) {
    byte data = Wire.receive();

#ifdef DEBUG
    log.put(data);
#endif

    in[i] = data;
  }

  byte cmd = getCommand(length);

#ifdef DEBUG
  log.put(cmd);
  log.put(LOG_NEXT);
#endif

  if( cmd == CMD_READ ) sendEnabled = true; //aparently a send is expected after a read
  if( cmd == CMD_INITATE || cmd == CMD_SELECT ) { //not sure for CMD_SELECT, but code shows that
    byte tosend[] = { 1, 1 };
    outSize = 2;
    memcpy(out, tosend, outSize);
  }
  if( cmd == CMD_SLOT ) {
    byte tosend[] = { 18, 0, 1,  0, 0, 0, 0, 0, 0, 0, 0, 0x0F, 0, 0, 0, 0, 0, 0, 0 };
    outSize = 19;
    memcpy(out, tosend, outSize);
  }
  if( cmd == CMD_GET_UID ) {
    byte tosend[] = { 0, 0x00, 0x00, 0x00, 0xEE, 0xFF, 0xCA, 0x00, 0x00 }; // inject highscore here
    outSize = 2;
    memcpy(out, tosend, outSize);
  }

  interrupts();
}

void NabaztagInjector::processRequest() {
  if( sendEnabled && outSize > 0 ) {
    Wire.send(out, outSize);

#ifdef DEBUG
    log.put(outSize);
    log.put(LOG_OUT);
    log.put(LOG_NEXT);
#endif

  }
}

// Private //////////////////////////////////////////////////////

byte NabaztagInjector::getCommand(int length) {
  switch( length ) {
    case 4:
      if( in[0] == 0x01 && in[1] == 0x02 && in[2] == 0x06 && in[3] == 0x00 ) return CMD_INITATE;
      if( in[0] == 0x01 && in[1] == 0x02 && in[2] == 0x0E ) return CMD_SELECT; //forth byte is variable
      break;
    case 3:
      if( in[0] == 0x01 && in[1] == 0x01 && in[2] == 0x0B ) return CMD_GET_UID;
      if( in[0] == 0x01 && in[1] == 0x01 && in[2] == 0x0F ) return CMD_COMP;
      break;
    case 2:
      if( in[0] == 0x00 && in[1] == 0x10 ) return CMD_INIT;
      if( in[0] == 0x00 && in[1] == 0x00 ) return CMD_CLOSE;
      break;
    case 1:
      if( in[0] == 0x01 ) return CMD_READ;
      if( in[0] == 0x03 ) return CMD_SLOT;
      break;
   }
  return CMD_UNKNOWN;
}

// Preinstantiate Objects //////////////////////////////////////////////////////

NabaztagInjector Nabaztag = NabaztagInjector();