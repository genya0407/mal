def rep(ast)
  repl_env = {
    '+': proc { |a,b| a + b },
    '-': proc { |a,b| a - b },
    '*': proc { |a,b| a * b },
    '/': proc { |a,b| a / b }
  }
  EVAL(ast, repl_env)
end

def EVAL(ast, env)
  if ast.is_a?(Array)
    if ast.size == 0
      ast
    else
      lst = eval_ast(ast, env)
      lst[0].call(*lst[1..-1])
    end
  else
    eval_ast(ast, env)
  end
end

def eval_ast(ast, env)
  case ast
  when Symbol
    if env[ast].nil?
      raise "Symbol #{ast} not found."
    else
      env[ast]
    end
  when Array
    ast.map { |e| EVAL(e, env) }
  else
    ast
  end
end
