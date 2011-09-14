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

cmd = {
  100 => "---------------------------> OUT",
  110 => "-> init",
  111 => "-> initiate",

  119 => "-> slot_marker_rfid",
  120 => "-> select_tag_rfid",
  121 => "-> get_uid_rfid",

  123 => "-> completion_rfid",

  124 => "-> read",
  125 => "-> close",

  126 => "-> UNKNOWN",
  127 => "\n"
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