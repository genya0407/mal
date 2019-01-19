require 'singleton'

module Value
  module Internals
    class True
      include Singleton
    end

    class False
      include Singleton
    end

    class Nil
      include Singleton
    end
  end

  True = Internals::True.instance.freeze
  False = Internals::False.instance.freeze
  Nil = Internals::Nil.instance.freeze

  class String
    attr_reader :content

    def initialize(content)
      @content = content
    end

    def ==(right)
      if right.is_a?(Value::String)
        self.content == right.content
      else
        false
      end
    end
  end
end
