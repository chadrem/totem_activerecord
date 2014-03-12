module TotemActiverecord
  module ShellCmds
    class Db < Totem::ShellCmds::Base
      def run
        case @argv[0]
        when 'create'
        when 'drop'
        when 'migrate'
        when 'rollback'
          rollback
        end
      end

      def create
        ActiveRecord::Base.establish_connection(TotemActiverecord.config.merge('database' => nil))
        ActiveRecord::Base.connection.create_database(TotemActiverecord.config['database'], options)
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

        Totem.db_reconnect

        return true
      end

      def rollback
        ActiveRecord::Migrator.rollback(TotemActiverecord.migrations_path, 1)
        TotemActiverecord.reconnect

        return true
      end
    end
  end
end

Totem::Shell.register_cmd(:db, TotemActiverecord::ShellCmds::Db)
