class InsertTweets
  require "mongo"
  include Mongo

  def self.run
    logger = Rails.logger
    config = {}
    File.open(Rails.root.join('config', 'mongoid.yml')) do |fd|
      config = YAML::load(fd)
    end
    env = Rails.env
    host = config[env]['host']
    port = ENV['MONGO_RUBY_DRIVER_PORT'] || Connection::DEFAULT_PORT
    db_name = config[env]['database']
    puts "Connecting to #{host}:#{port}:#{db_name}"

    EventMachine.synchrony do

      # open em-mongo connection
      coll = Mongo::Connection.new(host, port, :connect => true).db(db_name).collection('tweets')

      # Read sample stream using Twitter streaming API
      TweetStream::Client.new.on_error do |message|
        logger.debug message
        puts message
      end.sample do |status, client|
        if (status.place && status.place.bounding_box)
          box = status.place.bounding_box.coordinates.flatten
          long = (box[0].to_i + box[4].to_i)/2 # average out long and lat
          lat = (box[1].to_i + box[5].to_i)/2
          # puts "#{status.text} country: #{status.place.country}, long: #{long}, lat: #{lat}"
          # Save tweets in mongodb with approximate coordinates
          begin
            Tweet.create(:text => status.text, :when => DateTime.parse(status.created_at), :location => {:lng => long, :lat => lat})
          rescue
            EventMachine.stop
            client.stop
            raise
          end 
        end
      end
    end
  end
end


