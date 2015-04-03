class Column

  attr_accessor :name, :offset, :length, :type, :key, :ftype
  attr_accessor :hidden

  def grid_ftype
    return ftype if ftype
    return "STRING"
  end

end
