task :pull_tweets => :environment do
  LoadStream.run
end
