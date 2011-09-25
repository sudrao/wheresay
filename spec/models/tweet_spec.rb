require "spec_helper"

describe Tweet do
  before :all do
    NewCappedCollection.make('tweets', 10)
    Tweet.create_indexes
  end
  
  it "checks if tweet has text" do
    Tweet.create(location: {:lat => 10.0, :lng => 10.0}).should have(1).error_on(:text)
  end
  
  it "checks that location is sane" do
    Tweet.create(text: "Hello!", location: {:lat => -181.0, :lng => 10.0 }).should have(1).error_on(:location)
  end
  
  it "checks there is time stamp" do
    Tweet.create(text: "Hello!", location: {:lat => 10.0, :lng => 10.0}).should have(1).error_on(:when)
  end
  
  it "saves a valid tweet" do
    Tweet.create(text: "Hello!", when: DateTime.now, location: {:lat => 10.0, :lng => 10.0}).should have(:no).errors
  end
  
  def make_tweets(count=1, lat=10.0, lng=10.0)
    count.times do |i|
      Tweet.create(text: "Hello #{i}!", when: DateTime.now, location: {:lat => lat, :lng => lng})
    end
  end
  
  it "finds nearby tweets" do
    lat = 34.0
    lng = -74.0
    make_tweets(10, lat, lng)
    make_tweets(10, lat+20, lng-20) # far away
    # look for slightly different lat/lng
    tweets = Tweet.where(:location.near => [lng-1, lat+1]).order('when DESC').limit(50).all
    tweets.length.should be(10)
  end
  
end

    