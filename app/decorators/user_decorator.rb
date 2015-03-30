class UserDecorator < Draper::Decorator

  delegate_all

  #
  #  return list of names seperated by comma
  #
  def names_comma(col, gc = false)
    return col.map { |d| name_qual(d, gc) }.join(", ").html_safe
  end

  #
  #  return name qualified by u- or g-
  #
  def name_qual(obj, gc = false)
    if !gc
      return obj.name
    else
      if !obj.ind
        return "g-" + obj.name
      else
        return "u-" + obj.name
      end
    end
  end

end
