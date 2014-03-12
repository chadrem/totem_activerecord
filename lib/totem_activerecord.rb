require 'totem'
require 'active_record'

require 'totem_activerecord/version'
require 'totem_activerecord/shell_cmds/db'

module TotemActiverecord
  def self.config_path
    return File.join(Totem.root, 'config', 'database.yml')
  end

  def self.migrations_path
    return File.join(Totem.root, 'db', 'migrate')
  end

  def self.config
    return (@config ||= YAML.load_file(config_path)[Totem.env])
  end

  def self.connect
    return false if connected?

    begin
      ActiveRecord::Base.establish_connection(TotemActiverecord.config)
    rescue Exception => e
      puts "Failed to establish DB connection: #{e.message}\n#{e.backtrace.join("\n")}"
      return false
    end

    return true
  end

  def self.disconnect
    return false unless connected?

    ActiveRecord::Base.connection_pool.disconnect!

    return true
  end

  def self.reconnect
    disconnect
    connect

    return true
  end

  def self.connected?
    return !!ActiveRecord::Base.connected?
  end
end
