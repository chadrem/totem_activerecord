module TotemActiverecord
  module ShellCmds
    class Db < Totem::ShellCmds::Base
      def run
        case @args[0]
        when 'create'    then create
        when 'drop'      then drop
        when 'migrate'   then migrateb
        when 'rollback'  then rollback
        when 'migration' then migration(@args[1])
        else
          puts_usage
        end
      end

      def create
        ActiveRecord::Base.establish_connection(TotemActiverecord.config.merge('database' => nil))
        ActiveRecord::Base.connection.create_database(TotemActiverecord.config['database'])
        ActiveRecord::Base.establish_connection(TotemActiverecord.config)

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
        if name.length == 0
          puts "ERROR: You must provide a name for the migration."
          puts
          puts_usage
          return
        end

        name = name.gsub(/\s/,'_')
        timestamp =  Time.now.utc.strftime("%Y%m%d%H%M%S")
        filename = "#{timestamp}_#{name}.rb"
        path = File.join(Totem.root, 'db', 'migrate', filename)
        content = "class #{name.camelize} < ActiveRecord::Migration\nend"

        puts "Creating migration: #{path}"

        if File.exists?(path)
          puts "ERROR: Migration already exists."
          return false
        end

        File.open(path, 'w') { |f| f.write(content) }

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
        puts "  migration <name> - Create a new migration for the given name."
      end
    end
  end
end

Totem::Shell.register_cmd(:db, TotemActiverecord::ShellCmds::Db)
