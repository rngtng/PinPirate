/*
   PinPirate.cpp -
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

#include <PinPirate.h>

#include <TimerOne.h>


#define READ_BUFFER_SIZE 128

volatile byte readBuffer[READ_BUFFER_SIZE];
volatile byte writePointer = 0;
byte readPointer = 0;
volatile byte commandBuffer[READ_BUFFER_SIZE];
int k;
volatile int l;

volatile int length = 0;
volatile byte prevClock = 0;
volatile byte clock = 0;

void measure() {
  clock = READ_CLK;

  if(prevClock == 0 && clock == 1) { //raising clock
    READ_CHAN1 READ_CHAN2
    //if length = 0, length = READ_CHAN1 + (READ_CHAN2 << 4)
    else
     buffer.push()
    
  }
  prevClock = clock;
}

void init() {
  //init pins as INPUT
  for(int pin = 2; pin <= 13; pin++ ) {
    pinMode(pin, INPUT);
  }

  //prepate Timer
  Timer1.initialize(20); // 0.02us period = 50kHz
  Timer1.attachInterrupt(measure);
}

