class NewCappedCollection
  require 'mongo'
  require 'yaml'

  include Mongo

  def self.make(collection, limit)
    config = {}
    File.open(Rails.root.join('config', 'mongoid.yml')) do |fd|
      config = YAML::load(fd)
    end
    env = Rails.env
    host = config[env]['host']
    port = ENV['MONGO_RUBY_DRIVER_PORT'] || Connection::DEFAULT_PORT
    db_name = config[env]['database']
    puts "Connecting to #{host}:#{port}:#{db_name}"
    db = Connection.new(host, port, :connect => true).db(db_name)
    db.drop_collection(collection)

    # A capped collection has a max size and, optionally, a max number of records.
    # Old records get pushed out by new ones once the size or max num records is reached.
    coll = db.create_collection(collection, :capped => true, :size => limit*200, :max => limit)

  end
end
