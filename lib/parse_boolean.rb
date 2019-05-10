class ParseBoolean
  def self.from_int_or_str(value)
    case value
    when true, 'true', 1, '1'
      return true
    when false, 'false', 0, '0'
      return false
    else
      nil
    end
  end
end