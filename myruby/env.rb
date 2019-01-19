class Env
  def initialize(outer=nil, binds: [], exprs: [])
    @outer = outer
    @data = {}
    binds.zip(exprs).each do |k, v|
      self.set(k, v)
    end
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
