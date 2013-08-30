require 'active_support/core_ext/class/subclasses'

module Hydra
  module Migrate
    class Dispatcher
      def initialize(path=nil)
        self.load_migrations(path) unless path.nil?
      end

      def migrations
        @migrations || reset!
      end
      protected :migrations

      def reset!
        @migrations ||= Hash.new { |h,k| h[k] = [] }
      end

      def load_migrations(path)
        result = []
        Dir[File.join(path,'**','*.rb')].each { |migration_file|
          existing_migrations = Hydra::Migrate::Migration.descendants
          load(migration_file)
          new_migrations = Hydra::Migrate::Migration.descendants - existing_migrations
          new_migrations.each { |klass| klass.new(self) }
          result = new_migrations
        }
        result
      end

      def define_migration(signature={}, block)
        memo = { :from=>signature[:from].to_s, :to=>signature[:to].to_s, :block=>block }
        self.migrations[signature[:for]] << memo unless self.migrations[signature[:for]].include?(memo)
      end

      def migrations_for(target, constraints={})
        raise "Not a migratable object: #{target.inspect}" unless target.is_a?(Hydra::ModelMixins::Migratable)
        if self.migrations.has_key?(target.class)
          migrations[target.class].select { |v| 
            v[:from].to_s == constraints[:from].to_s and (constraints[:to].nil? or v[:to].to_s == constraints[:to].to_s)
          }
        else
          return []
        end
      end

      def can_migrate?(object, constraints={})
        object.is_a?(Hydra::ModelMixins::Migratable) and not migrations_for(object, {:from=>object.current_migration}.merge(constraints)).empty?
      end

      def migrate!(*args)
        opts = args.last.is_a?(Hash) ? args.pop : {}
        objects=args.flatten
        objects.each { |object|
          raise "Not a migratable object: #{object.inspect}" unless object.is_a?(Hydra::ModelMixins::Migratable)
        }
  
        objects.collect { |object|
          migrations_for(object, :from=>object.current_migration, :to=>opts[:to]).each do |migration|
            yield(object,migration,self) if block_given?
            migration[:block].call(object, migration[:to], self)
            object.migrationInfo.migrate(migration[:to])
            object.current_migration = migration[:to]
            object.save(:validate=>false) unless opts[:dry_run]
          end
          object
        }
      end

      def self.migrate_all!(*args, &block)
        opts = {path: '.'}
        opts.merge!(args.pop) if args.last.is_a?(Hash)
        dispatcher = self.new(opts[:path])
        models = args
        models << ActiveFedora::Base if models.empty?
        models.flatten.each do |klass|
          klass.find_each({},{:cast=>true}) do |obj|
            while dispatcher.can_migrate? obj and (opts[:to].nil? or obj.current_migration != opts[:to])
              dispatcher.migrate!(obj, &block)
            end
          end
        end
      end
    end
  end
end
