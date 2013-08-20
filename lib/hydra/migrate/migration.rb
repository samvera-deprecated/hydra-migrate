module Hydra
  module Migrate
    class Migration
      class << self
        def actions
          @actions ||= []
        end

        def migrates klass
          unless klass.is_a?(Class) and klass.ancestors.include?(Hydra::ModelMixins::Migratable)
            raise TypeError, "Unknown migratable class: #{klass.to_s}"
          end
          @target_class = klass
        end

        def target_class
          return @target_class if @target_class
          klass = Module.const_get(self.name.sub(/Migration$/,'').to_sym)
          migrates klass
        end
        
        def migrate opts={}, &block
          unless opts.is_a?(Hash) and opts.length == 1
            raise ArgumentError, "migrate <from_version> => <to_version>"
          end

          actions << [{:for=>target_class, :from=>opts.keys.first, :to=>opts.values.first}, block]
        end
      end

      def initialize(migrator)
        self.class.actions.each { |action| migrator.define_migration(*action) }
      end
    end
  end
end
