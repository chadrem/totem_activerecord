module TotemActiverecord
  module ShellCmds
    class Db < Totem::ShellCmds::Base
      def run
        case @args[0]
        when 'create'    then create
        when 'drop'      then drop
        when 'migrate'   then migrate
        when 'rollback'  then rollback
        when 'migration' then migration(@args[1])
        when 'up'        then up(@args[1])
        when 'down'      then down(@args[1])
        else
          puts_usage
        end
      end

      def create
        ActiveRecord::Base.establish_connection(TotemActiverecord.config.merge('database' => nil))
        ActiveRecord::Base.connection.create_database(TotemActiverecord.config['database'])
        ActiveRecord::Base.establish_connection(TotemActiverecord.config)
        TotemActiverecord.reconnect

        return true
      end

      def drop
        ActiveRecord::Base.connection.drop_database(TotemActiverecord.config['database'])

        return true
      end

      def migrate
        ActiveRecord::Migration.verbose = true
        ActiveRecord::Migrator.migrate(TotemActiverecord.migrations_path)
        TotemActiverecord.reconnect

        return true
      end

      def rollback
        ActiveRecord::Migrator.rollback(TotemActiverecord.migrations_path, 1)
        TotemActiverecord.reconnect

        return true
      end

      def migration(name)
        return false unless require_arg(name, :name)

        name = name.gsub(/\s/,'_')
        timestamp =  Time.now.utc.strftime("%Y%m%d%H%M%S")
        filename = "#{timestamp}_#{name}.rb"
        path = File.join(Totem.root, 'db', 'migrate', filename)
        content = "class #{name.camelize} < ActiveRecord::Migration\nend"

        puts "Creating migration: #{path}"

        if File.exists?(path)
          puts_error('Migration already exists.')
          return false
        end

        File.open(path, 'w') { |f| f.write(content) }

        return true
      end

      def up(timestamp)
        return false unless require_arg(timestamp, :timestamp)

        ActiveRecord::Migration.verbose = true
        ActiveRecord::Migrator.up(TotemActiverecord.migrations_path, timestamp.to_i)
        TotemActiverecord.reconnect

        return true
      end

      def down(timestamp)
        return false unless require_arg(timestamp, :timestamp)

        ActiveRecord::Migration.verbose = true
        ActiveRecord::Migrator.down(TotemActiverecord.migrations_path, timestamp.to_i)
        TotemActiverecord.reconnect

        return true
      end

      private

      def puts_usage
        puts "Usage:\n  bundle exec totem db <command>"
        puts
        puts "Commands:\n"
        puts "  create           - Create the database if it doesn't exist."
        puts "  drop             - Drop the database if it exists."
        puts "  migrate          - Run all new migrations."
        puts "  rollback         - Rollback one migration."
        puts "  migration <name> - Create a new migration with <name>."
        puts "  up <name>        - Run 'up' method in the <name> migration."
        puts "  down <name>      - Run 'down' method in the <name> migration."
      end

      def puts_error(message)
          puts "ERROR: #{message}"
          puts
          puts_usage
      end

      def require_arg(val, name)
        if val.nil? || val.length == 0
          puts_error("You must provide a #{name}.")
          return false
        end

        return true
      end
    end
  end
end

Totem::Shell.register_cmd(:db, TotemActiverecord::ShellCmds::Db)
