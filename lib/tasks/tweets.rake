COLLECTION_EXISTS = "tmp/tweet_#{Rails.env}" # if file exists, collection exists

task :pull_tweets =>  [COLLECTION_EXISTS, :environment] do
  LoadStream.run
end

# Make collection forcibly
task :make_capped => :environment do
  NewCappedCollection.make('tweets', MAX_DB_ENTRIES)
  touch(COLLECTION_EXISTS)
end

# Make collection if absent
file COLLECTION_EXISTS do
  Rake::Task['make_capped'].invoke
end
