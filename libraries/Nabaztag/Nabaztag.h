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

#ifdef DEBUG
#include <ByteBuffer.h>
#define LOG_SIZE 256
#define LOG_OUT  100
#define LOG_NEXT 127
#endif

#define CRX14_ADR    80

#define CMD_INIT     120   // 0 1
#define CMD_INITATE  121   // 1 2 6 0
#define CMD_SLOT     122   // 3
#define CMD_SELECT   123   // 1 2 E
#define CMD_GET_UID  124   // 1 1 B
#define CMD_COMP     125   // 1 1 F
#define CMD_READ     126   // 1
#define CMD_CLOSE    127   // 0 0
#define CMD_UNKNOWN  128

class NabaztagInjector
{
  private:
    static byte in[];
    static uint8_t out[];
    static int outSize;
    static volatile boolean sendEnabled;

    byte getCommand(int length);
  public:
#ifdef DEBUG
    static ByteBuffer log;
#endif

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

