class Hash
  def to_stream
    values = to_a
    (0...values.size)
    .to_stream
    .map{ |i|
      Hash[*values[i]]
    }
  end
end
