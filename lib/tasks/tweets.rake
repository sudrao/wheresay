COLLECTION_EXISTS = "tmp/tweet_#{Rails.env}" # if file exists, collection exists

task :pull_tweets =>  [COLLECTION_EXISTS, :environment] do
  LoadStream.run
end

# Make collection (forcibly)
task :make_capped => :environment do
  NewCappedCollection.make('tweets', 100000)
  touch(COLLECTION_EXISTS)
end

file COLLECTION_EXISTS => :make_capped
