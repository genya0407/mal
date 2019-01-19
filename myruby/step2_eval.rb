require './reader'
require './printer'
require './evaluator'

def READ
  Reader.read_str(readline)
end

def PRINT(ast)
  puts pr_str(ast)
end

loop do
  puts "user> "
  begin
    PRINT(rep(READ()))
  rescue => e
    puts "Error: #{e}"
  end
end
