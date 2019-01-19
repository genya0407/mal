def pr_str(ast, print_readably: false)
  case ast
  when Array
    "(#{ast.map {|a| pr_str(a) }.join(" ")})"
  when Value::True
    "true"
  when Value::False
    "false"
  when Value::Nil
    "nil"
  when Proc
    "#<function>"
  when Value::String
    if print_readably
      chars = []
      orig_chars = ast.content.each_char.to_a
      i = 0
      while i < orig_chars.size do
        if orig_chars[i] != '\\'
          chars.push(orig_chars[i])
        else
          case orig_chars[i+1]
          when '"'
            chars.push('"')
          when 'n'
            chars.push("\n")
          when '\\'
            chars.push('\\')
          else
            raise "Undefined special character \\#{orig_chars[i+1]}."
          end
          i += 1
        end
        i += 1
      end
      '"' + chars.join('') + '"'
    else
      '"' + ast.content + '"'
    end
  else
    ast.to_s
  end
end
