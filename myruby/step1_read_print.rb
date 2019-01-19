require './reader'
require './printer'

def READ
  Reader.read_str(readline)
end

def rep(line)
  line
end

def PRINT(ast)
  puts pr_str(ast)
end

loop do
  puts "user> "
  PRINT(rep(READ()))
end
