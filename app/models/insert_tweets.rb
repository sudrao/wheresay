class InsertTweets
  require 'fiber'
  

  def self.run
#    logger = Rails.logger
    config = {}
    File.open(Rails.root.join('config', 'mongoid.yml')) do |fd|
      config = YAML::load(fd)
    end
    env = Rails.env
    host = config[env]['host']
    port = ENV['MONGO_RUBY_DRIVER_PORT'] || EM::Mongo::DEFAULT_PORT
    db_name = config[env]['database']
    puts "Connecting to #{host}:#{port}:#{db_name}"

    EventMachine.run do
      # open em-mongo connection
      coll = EM::Mongo::Connection.new(host, port).db(db_name).collection('tweets')

      # Read sample stream using Twitter streaming API
      TweetStream::Client.new.on_error do |message|
#        logger.debug message
        puts message
      end.sample do |status, client|
        if (status.place && status.place.bounding_box)
          box = status.place.bounding_box.coordinates.flatten
          long = (box[0].to_i + box[4].to_i)/2 # average out long and lat
          lat = (box[1].to_i + box[5].to_i)/2
          puts "#{status.text} country: #{status.place.country}, long: #{long}, lat: #{lat}"
          # Save tweets in mongodb with approximate coordinates
          begin
            # todo: need an id
            tw = {:text => status.text, :when => DateTime.parse(status.created_at).to_time, :location => {:lng => long, :lat => lat}}
            # Create a short lived fiber to do the insert.
            Fiber.new do
              resp = insert(coll, tw)
              unless resp
#                logger.debug "Failed to insert tweet"
                puts "Failed to insert tweet"
              end
            end.resume
          rescue
            client.stop
            EventMachine.stop
            raise
          end 
        end
      end
    end
  end

  def self.insert(coll, tweet)
    f = Fiber.current
    insert_resp = coll.safe_insert(tweet) # insert but don't wait for completion
    insert_resp.callback { f.resume(insert_resp) }
    insert_resp.errback { f.resume(nil) }

    return Fiber.yield
  end
end
