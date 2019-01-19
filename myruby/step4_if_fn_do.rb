require './reader'
require './printer'
require './evaluator'
require './env'
require './core'

def READ
  Reader.read_str(readline)
end

def PRINT(ast)
  puts pr_str(ast)
end

env = Env.new
CF.each do |fname, body|
  env.set(fname, body)
end

loop do
  puts "user> "
  begin
    PRINT(rep(READ(), env))
  rescue => e
    puts "Error: #{e}"
  end
end
