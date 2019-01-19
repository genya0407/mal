require './values'

class Reader
  PCRE = /[\s,]*(~@|[\[\]{}()'`~^@]|"(?:\\.|[^\\"])*"|;.*|[^\s\[\]{}('"`,;)]*)/.freeze

  class << self
    def read_str(str)
      tokens = tokenizer(str)
      reader = self.new(tokens)
      reader.read_form
    end

    def tokenizer(str)
      tokens = []
      start = 0
      loop do
        m = PCRE.match(str, start)
        if m[1] == ""
          break
        end

        tokens.append(m[1])
        start = m.end(1)
      end
      return tokens
    end
  end

  def initialize(tokens)
    @tokens = tokens
    @position = 0
  end

  def next
    token = self.peek
    @position += 1
    return token
  end

  def peek
    @tokens[@position]
  end

  def read_form
    if self.left_paren?
      self.read_list
    else
      self.read_atom
    end
  end

  def read_list
    ast = []
    self.next
    loop do
      if self.right_paren?
        self.next
        break
      elsif self.peek.nil?
        raise "Parens not matched!"
      else
        ast.append(self.read_form)
      end
    end

    return ast
  end

  def read_atom
    if self.isint?
      self.next.to_i
    elsif self.istrue?
      self.next
      Value::True
    elsif self.isfalse?
      self.next
      Value::False
    elsif self.isnil?
      self.next
      Value::Nil
    elsif self.isstring?
      Value::String.new(self.next.match(/"(.*)"/)[1])
    else
      self.next.to_sym
    end
  end

  def isint?
    self.peek.match(/^\s*\d+\s*/)
  end

  def istrue?
    self.peek == 'true'
  end

  def isfalse?
    self.peek == 'false'
  end

  def isnil?
    self.peek == 'nil'
  end

  def isstring?
    !self.peek.match(/"(.*)"/).nil?
  end

  def left_paren?
    self.peek == '(' || self.peek == '['
  end

  def right_paren?
    self.peek == ')' || self.peek == ']'
  end
end
