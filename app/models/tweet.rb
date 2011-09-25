class Tweet
  include Mongoid::Document
  include Mongoid::Spacial::Document
  include LocationHelper
  
  field :text, type: String # actual tweet
  field :when, type: DateTime
  # Approximate longitude, lattitude where tweeted
  field :location, type: Array, spacial: true
  spacial_index :location
  index :when
  
  validates_presence_of :text, :when
  validate :location_within_range
    
  def location_within_range
    unless loc_valid?(location)
      errors.add(:location, "coordinates are out of range (+ or - 180 degrees)")
    end
  end
end
