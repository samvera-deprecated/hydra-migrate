require "hydra/datastream/migration_info"
require "hydra/migrate/version"
require "hydra/migrate/dispatcher"
require "hydra/migrate/migration"
require "hydra/model_mixins/migratable"
require 'hydra/migrate/engine' if defined?(Rails)

module Hydra
  module Migrate
  end
end
