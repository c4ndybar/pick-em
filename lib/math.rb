
module Math
  def self.median(array)
    raise ArgumentError.new("#{array} is not an array") if (!array.is_a?(Array))
    return 0 if (!array || array == [])
    
    sorted = array.sort
    len = sorted.length
    (sorted[(len - 1) / 2] + sorted[len / 2]) / 2.0
  end
end