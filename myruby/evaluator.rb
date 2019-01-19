def rep(ast, env)
  EVAL(ast, env)
end

Fn = Struct.new(:ast, :params, :env, :fn)

def EVAL(ast, env)
  loop do
    if ast.is_a?(Array)
      if ast.size == 0
        return ast
      else
        case ast[0]
        when :def!
          return env.set(ast[1], EVAL(ast[2], env))
        when :'let*'
          new_env = Env.new(env)
          new_bindings = ast[1]
          new_bindings.each_slice(2) do |k, v|
            new_env.set(k, EVAL(v, new_env))
          end
          ast = ast[2]
          env = new_env
          next
          # return EVAL(ast[2], new_env)
        when :do
          ast[1..-2].map { |a| EVAL(a, env) }
          ast = ast.last
          next
          # return ast[1..-1].map { |a| EVAL(a, env) }.to_a.last
        when :if
          cond = ast[1]
          left = ast[2]
          right = ast[3]
          case EVAL(cond, env)
          when Value::False
            if right.nil?
              return Value::Nil
            else
              ast = right
              next
              # return EVAL(right, env)
            end
          when Value::Nil
            ast = right
            next
            # return EVAL(right, env)
          else
            ast = left
            next
            # return EVAL(left, env)
          end
        when :'fn*'
          body = ast[2]
          params = ast[1]
          fn = proc do |*exprs|
            func_env = Env.new(env, binds: params, exprs: exprs)
            EVAL(body, func_env)
          end
          return Fn.new(body, params, env, fn)
        else
          lst = eval_ast(ast, env)
          fn = lst[0]
          if fn.is_a?(Fn)
            ast = fn.ast
            env = Env.new(fn.env, binds: fn.params, exprs: lst[1..-1])
            next
          else
            return fn.call(*lst[1..-1])
          end
        end
      end
    else
      return eval_ast(ast, env)
    end
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
