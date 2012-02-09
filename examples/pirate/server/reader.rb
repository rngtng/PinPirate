# taken from:  http://www.arduino.cc/playground/Interfacing/Ruby

require "serialport"

#params for serial port
PORT = ARGV.first
puts PORT
BAUD_RATE = 115200

sp = SerialPort.new(PORT, BAUD_RATE)


class FI
  MAXCNT = 7

  HIGHSCORE = 12

  def initialize
    @parse = false
    @cnt = 0
    @score = 0
  end

  def s2d(value)
    value  = "%08b" % value
    [value[0..3].to_i(2), value[4..7].to_i(2)]
  end

  def add(v)
     if @cnt < 0
       @cnt = v
     elsif @parse
       pot = (@cnt + 1) * 2
       first, last = s2d(v)
       @score += first * (10 ** pot)
       @score += last  * (10 ** (pot - 1))
     elsif v == HIGHSCORE
       @parse = true
       @score = 0
     else
       #print "u#{v} "
     end
     @cnt -= 1

     if @cnt < 0
       if @parse
         puts @score
         @parse = false
       end
     end

  end
end

f = FI.new

#just read forever
while true do
  v = sp.getc.unpack("C*").first
  print v
  print " "
  
#  f.add(v.to_i)
end

sp.close