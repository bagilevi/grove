require 'drb'

module Grove


  ## Client


  @@services = {}

  def self.const_missing const
    if @@services.has_key? const
      @@services[const]
    else
      @@services[const] = get const
    end
  end

  def self.get const
    service_config = config[const]
    ::DRbObject.new_with_uri(service_config)
  end


  ## Server


  def self.run_service front_object
    trap("INT") { puts; exit }
    uri = nil
    t = Thread.new {
      $SAFE = 1
      server = ::DRb.start_service(nil, front_object)
      uri = server.uri
      ::DRb.thread.join
    }
    while uri.nil?
      sleep 0.01
    end
    set_config(front_object.name, uri)
    puts "Started #{front_object.name} service on #{uri}"
    t.join
  end


  ### Config


  def self.config
    if File.exists?(config_file)
      File.open(config_file, File::RDONLY) { |f| read_config(f) }
    else
      {}
    end
  end

  def self.set_config const, service_config
    File.open(config_file, File::CREAT|File::RDWR) { |f|
      f.flock(File::LOCK_EX)
      read_config(f)
      @@config[const.to_sym] = service_config
      f.truncate 0
      f.rewind
      write_config(f)
    }
  end

  def self.read_config(f)
    @@config = Hash[(
      f.read.split(/[\r\n]+/).map do |line|
        a = line.split(':',2).map(&:strip)
        if a.size
          [a[0].to_sym, a[1]]
        end
      end.compact
    )]
  end

  def self.write_config(f)
    @@config.each do |key, value|
      f.puts "#{key}:#{value}"
    end
  end

  def self.config_file
    "#{ENV['HOME']}/.ruby-grove"
  end

end


