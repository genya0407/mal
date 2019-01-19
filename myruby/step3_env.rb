require './reader'
require './printer'
require './evaluator'
require './env'

def READ
  Reader.read_str(readline)
end

def PRINT(ast)
  puts pr_str(ast)
end

env = Env.new
[:+, :-, :*, :/].each do |s|
  env.set(s, proc { |a, b| a.send(s, b) })
end

loop do
  puts "user> "
  begin
    PRINT(rep(READ(), env))
  rescue => e
    puts "Error: #{e}"
  end
end
