class Env
  def initialize(outer=nil)
    @outer = outer
    @data = {}
  end

  def set(key, val)
    @data[key] = val
  end

  def find(key)
    @data.has_key?(key) ? @data : @outer&.find(key)
  end

  def get(key)
    d = self.find(key)
    if d.nil?
      raise "Symbol #{key} not found."
    else
      d[key]
    end
  end
end
