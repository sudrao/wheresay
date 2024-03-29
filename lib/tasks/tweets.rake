require Rails.root.join('app/models/insert_tweets')

COLLECTION_EXISTS = "tmp/tweet_#{Rails.env}" # if file exists, collection exists

task :pull_tweets =>  [COLLECTION_EXISTS] do
  InsertTweets.run
end

# Make collection forcibly
task :make_capped => :environment do
  NewCappedCollection.make('tweets', MAX_DB_ENTRIES)
  Tweet.create_indexes
  touch(COLLECTION_EXISTS)
end

# Make collection if absent
file COLLECTION_EXISTS do
  Rake::Task['make_capped'].invoke
end
