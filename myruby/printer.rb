def pr_str(ast)
  case ast
  when Array
    "(#{ast.map {|a| pr_str(a) }.join(" ")})"
  when Symbol
    ast.to_s
  when Integer
    ast.to_s
  end
end
