# taken from:  http://www.arduino.cc/playground/Interfacing/Ruby

# 1 1 15 0 0 0 16 1 2 6 0 1 1 1 15 0 0 
# 1 1 15 0 0 0 16 1 2 6 0 1 1 1 15 0 0 
# 1 1 15 0 0 0 16 1 2 6 0 1 1 1 15 0 0 
# 1 1 15 0 0 0 16 1 2 6 0 1 1 1 15 0 0 
# 1 1 15 0 0 0 16 1 2 6 0 1 1 1 15 0 0 
# 1 1 15 0 0 0 16 1 2 6 0 1 1 1 15 0 0 
# 1 1 15 0 0 0 16 1 2 6 0 1 1 1 15 0 0 
# 1 1 15 0 0 0 16 1 2 6 0 1 1 1 15 0 0 
# 1 1 15 0 0 0 16 1 2 6 0 1 1 1 15 0 0 
# 1 1 15 0 0 0 16 1 2 6 0 1 1 1 15 0 0 
# 1 1 15 0 0 0 16 1 2 6 0 1 1 1 15 0 0 
# 1 1 15 0 0 0 16 1 2 6 0 1 1 1 15 0 0 
# 1 1 15 0 0 0 16 1 2 6 0 1 1 1 15 0 0 
# 1 1 15 0 0 0 16 1 2 6 0 1 1 1 15 0 0 
# 1 1 15 0 0 0 16 1 2 6 0 1 1 1 15 0 0 
# 1 1 15 0 0 0 16 1 2 6 0 1 1 1 15 0 0 
# 1 1 15 0 0 0 16 1 2 6 0 1 1 1 15 0 0

require "serialport"

#params for serial port
PORT = ARGV.first
puts PORT
BAUD_RATE = 115200

sp = SerialPort.new(PORT, BAUD_RATE)


#just read forever
while true do
  v = sp.getc.unpack("C*").first
  if v == 111
    puts
  else
    print "#{v} "
  end
end

sp.close