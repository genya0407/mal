cf = {}

# arithmetics
[:+, :-, :*, :/].each do |s|
  cf[s] = proc { |a, b| a.send(s, b) }
end

def to_value(rb_value)
  if rb_value.nil?
    Value::Nil
  else
    rb_value ? Value::True : Value::False
  end
end

require './printer'
require './values'
cf[:prn] = proc { |s| puts pr_str(s, print_readably: true); Value::Nil }
cf[:list] = proc { |*args| args.nil? ? [] : args }
cf[:list?] = proc { |arg| to_value(arg.is_a?(Array)) }
cf[:empty?] = proc do |arg|
  raise "Not list." unless arg.is_a?(Array)
  to_value(arg.empty?)
end
cf[:count] = proc do |lst|
  case lst
  when Array
    lst.size
  when Value::Nil
    0
  else
    raise "Not list."
  end
end
cf[:'='] = proc do |left, right|
  case left
  when Array
    case
    when !right.is_a?(Array)
      Value::False
    when left.size != right.size
      Value::False
    when !(left.zip(right).all? { |l, r| cf[:'='].call(l, r) })
      Value::False
    else
      Value::True
    end
  else
    to_value(left == right)
  end
end

[:<, :<=, :>, :>=].each do |op|
  cf[op] = proc { |l, r| to_value(l.send(op, r)) }
end

CF = cf.freeze
