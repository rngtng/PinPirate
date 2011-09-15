/*
  Nabaztag.h -  Inject RFID library for Arduino & Wiring
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

#ifndef Nabaztag_h
#define Nabaztag_h

#include "WProgram.h"
#include <ByteBuffer.h>

#ifdef DEBUG
#define LOG_OUT  100 //TODO this need to be better
#define linit() logBuffer.init(256)
#define lprint(data) logBuffer.put(data)
#define lputs(data) logBuffer.put(data); logBuffer.puts(127)
ByteBuffer logBuffer;

#else
#define linit()
#define lprint(data)
#define lputs(data)
#endif

#define CRX14_ADR    80
#define DUMMY_ADR    23

#define CMD_INIT     120 // cmd: 0x00 0x01
#define CMD_INITATE  121 // cmd: 0x01 0x02 0x06 0x00
#define CMD_SLOT     122 // cmd: 0x03
#define CMD_SELECT   123 // cmd: 0x01 0x02 0x0E
#define CMD_GET_UID  124 // cmd: 0x01 0x01 0x0B
#define CMD_COMP     125 // cmd: 0x01 0x01 0x0F
#define CMD_READ     126 // cmd: 0x01
#define CMD_CLOSE    127 // cmd: 0x00 0x00
#define CMD_UNKNOWN  128

class NabaztagInjector
{
  private:
    static volatile boolean inited;       // init comand received, ok to go
    static volatile boolean sendEnabled;  // only response when true
    static int rfidPort;                  // pin where RFID chip is conected

    static byte in[];                     // in buffer for reading
    static uint8_t out[];                 // out buffer for sending
    static int outSize;                   // size of Buffer to send

    static ByteBuffer sendBuffer;         // actual data to send

    byte getCommand(int length);
    void enableRFID();
    void disableRFID();

  public:
    NabaztagInjector();
    void init(int);
    void send(uint8_t);
    void send(uint8_t*, uint8_t);
    void send(int);
    void send(char*);
    void processReceive(int length);
    void processRequest();
};

extern NabaztagInjector Nabaztag;

#endif

