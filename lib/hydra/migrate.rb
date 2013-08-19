require "hydra/migrate/version"
require "hydra/migrate/migration"
require "hydra/datastream/migration_info"

module Hydra
  module Migrate
    class << self
      @migrations = Hash.new { |h,k| h[k] = [] }

      def define_migration(signature, &block)
      end
    end
  end
end
