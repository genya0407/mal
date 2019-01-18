def READ
  readline
end

def rep(line)
  line
end

def PRINT(line)
  puts line
end

loop do
  puts "user> "
  PRINT(rep(READ()))
end
