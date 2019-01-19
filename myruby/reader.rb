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
    if self.peek == '('
      self.read_list
    else
      self.read_atom
    end
  end

  def read_list
    ast = []
    self.next
    loop do
      if self.peek == ')'
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
    atom = self.next
    if self.int?(atom)
      atom.to_i
    else
      atom.to_sym
    end
  end

  def int?(atom)
    atom.match(/\d+/)
  end
end
