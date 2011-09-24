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
    end.locations("-118.5, 34, -118.3, 34.06") do |status, client|
      puts "#{status.text} at #{status.place.bounding_box.inspect}"
      num_updates -= 1
      client.stop unless num_updates > 0
    end
  end
end

