a = ["5 12 0 1 80 0         ",
"5 12 0 2 80 0         ",
"5 12 0 3 0 0          ",
"5 12 0 3 80 0         ",
"5 12 0 4 0 0          ",
"5 12 0 4 80 0         ",
"5 12 0 5 0 0          ",
"5 12 0 5 80 0         ",
"5 12 0 6 0 0          ",
"5 12 0 6 80 0         ",
"5 12 0 7 0 0          ",
"5 12 0 7 80 0         ",
"5 12 0 8 0 0          ",
"5 12 0 8 80 0         ",
"5 12 0 9 0 0          ",
"5 12 0 9 80 0         ",
"5 12 0 16 0 0         ",
"5 12 0 16 80 0        ",
"5 12 0 17 0 0         ",
"5 12 0 17 80 0        ",
"5 12 0 18 0 0         ",
"5 12 0 18 80 0        ",
"5 12 0 19 0 0         ",
"5 12 0 19 80 0        ",
"5 12 0 20 0 0         ",
"5 12 0 20 80 0        ",
"5 12 0 21 0 0         ",
"5 12 1 4 130 16"]



def s2d(value)
  value  = "%08b" % value
  [value[0..3].to_i(2), value[4..7].to_i(2)]
end

a.each do  |row|
  row.split(' ').each do |value|
    print s2d(value.strip).join()
  end
  puts
end