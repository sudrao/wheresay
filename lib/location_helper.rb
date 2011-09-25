module LocationHelper
  
  def loc_valid?(location)
    (-90.0..90.0).cover?(location[:lat]) &&
      (-180.0..180.0).cover?(location[:lng])
  end
end