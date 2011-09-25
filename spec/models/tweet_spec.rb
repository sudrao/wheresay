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
end

    