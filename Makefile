#
# Makefile for an Arduino based logic analyzer using the 'arduino-core'
# package and makefiles.
#
#	$Id: Makefile,v 1.3 2011-03-07 02:47:26 gillham Exp $
#
ARDUINO_DIR  = /Applications/Arduino.app/Contents/Resources/Java
TARGET       = logic_analyzer
ARDUINO_LIBS = TimerOne
ARDUINO_LIB_PATH = /Users/tobi/Sites/eclipse/rainbowduino/data/firmware/lib
AVRDUDE_CONF = /Applications/Arduino.app/Contents/Resources/Java/hardware/tools/avr/etc/avrdude.conf


MCU          = atmega328p
#MCU          = atmega1280
F_CPU        = 16000000
ARDUINO_PORT = /dev/tty.usb*
AVRDUDE_ARD_BAUDRATE = 57600
AVRDUDE_ARD_PROGRAMMER = stk500v1

include ~/Sites/arduino/arduino-mk/Arduino.mk

