class LoadStream

  def self.run
    num_updates = 10
    logger = Rails.logger
    TweetStream::Client.new.on_error do |message|
      logger.debug message
      puts message
    end.on_delete do |status_id, user_id|
      # handle delete
      logger.debug "Twitter delete for #{status_id.to_s}, #{user_id.to_s}"
      puts "Twitter delete for #{status_id.to_s}, #{user_id.to_s}"
    end.on_limit do |skip_count|
      logger.debug "Skipped #{skip_count.to_s} updates"
    end.sample do |status, client|
      if (status.place)
        box = status.place.bounding_box.coordinates.flatten
        long = (box[0].to_i + box[4].to_i)/2 # average out long and lat
        lat = (box[1].to_i + box[5].to_i)/2
        puts "#{status.text} country: #{status.place.country}, long: #{long}, lat: #{lat}"
        tw = Tweet.create(:text => status.text, :location => {:long => long, :lat => lat})
        num_updates -= 1
      end
      client.stop unless num_updates > 0
    end
  end
end

