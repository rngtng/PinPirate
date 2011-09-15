#
# Makefile for an Arduino based pinpirate using the 'arduino-core'
# package and makefiles.
#
#
ARDUINO_DIR            = /Applications/Arduino.app/Contents/Resources/Java
TARGET                 = pinpirate
ARDUINO_LIBS           = Nabaztag Wire Wire/utility ByteBuffer
ARDUINO_LIB_PATH       = ./libraries
AVRDUDE_CONF           = /Applications/Arduino.app/Contents/Resources/Java/hardware/tools/avr/etc/avrdude.conf


MCU                    = atmega328p
#MCU                    = atmega1280
F_CPU                  = 16000000
ARDUINO_PORT           = /dev/tty.usb*
AVRDUDE_ARD_BAUDRATE   = 57600
AVRDUDE_ARD_PROGRAMMER = stk500v1

include ../arduino-mk/Arduino.mk

