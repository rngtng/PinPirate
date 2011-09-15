# taken from:  http://www.arduino.cc/playground/Interfacing/Ruby

# init_rfid: 0 16     # Turn ON electromagnetic field
# initiate_rfid: 1 2 6 0
# read_frame_rfid: 1
#
# completion_rfid: 1 1 15
# close: 0 0  # Turn OFF electromagnetic field
#
# completion_rfid: 1 1 15
# close: 0 0 # Turn OFF electromagnetic field
#

# slot_marker_rfid: 3

require "serialport"

#params for serial port
PORT = ARGV.first
puts PORT
BAUD_RATE = 115200

sp = SerialPort.new(PORT, BAUD_RATE)


#define CMD_INIT     120 // cmd: 0x00 0x01
#define CMD_INITATE  121 // cmd: 0x01 0x02 0x06 0x00
#define CMD_SLOT     122 // cmd: 0x03
#define CMD_SELECT   123 // cmd: 0x01 0x02 0x0E
#define CMD_GET_UID  124 // cmd: 0x01 0x01 0x0B
#define CMD_COMP     125 // cmd: 0x01 0x01 0x0F
#define CMD_READ     126 // cmd: 0x01
#define CMD_CLOSE    127 // cmd: 0x00 0x00
#define CMD_UNKNOWN  128


cmd = {
  100 => "---------------------------> OUT",

  120 => "-> init",
  121 => "-> initiate",
  122 => "-> slot_marker_rfid",
  123 => "-> select_tag_rfid",
  124 => "-> get_uid_rfid",
  125 => "-> completion_rfid",
  126 => "-> prepare to send",
  127 => "-> close",
  128 => "-> UNKNOWN",

  254 => "-> PING",
  111 => "\n"
}

#just read forever
while true do
  v = sp.getc.unpack("C*").first
  if val = cmd[v.to_i]
    print val
  else
    print "#{v.to_s(16).upcase} "
  end
end

sp.close