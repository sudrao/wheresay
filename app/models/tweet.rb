class Tweet
  include Mongoid::Document
  include Mongoid::Spacial::Document
  
  field :text, type: String # actual tweet
  # Approximate longitude, lattitude where tweeted
  field :location, type: Array, spacial: true
  spacial_index :location
  
  validates_presence_of :text
  validate :location_within_range
  
  def location_within_range
    low = -180.0
    high = 180.0
    unless  (low..high).cover?(location[:lat]) &&
      (low..high).cover?(location[:lng])
      errors.add(:location, "coordinates are out of range (+ or - 180 degrees)")
    end
  end
end
