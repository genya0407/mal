def rep(ast, env)
  EVAL(ast, env)
end

def EVAL(ast, env)
  if ast.is_a?(Array)
    if ast.size == 0
      ast
    else
      case ast[0]
      when :def!
        env.set(ast[1], EVAL(ast[2], env))
      when :'let*'
        new_env = Env.new(env)
        new_bindings = ast[1]
        new_bindings.each_slice(2) do |k, v|
          new_env.set(k, EVAL(v, new_env))
        end
        EVAL(ast[2], new_env)
      else
        lst = eval_ast(ast, env)
        lst[0].call(*lst[1..-1])
      end
    end
  else
    eval_ast(ast, env)
  end
end

def eval_ast(ast, env)
  case ast
  when Symbol
    env.get(ast)
  when Array
    ast.map { |e| EVAL(e, env) }
  else
    ast
  end
end
