module Hydra
  module ModelMixins
    module Migratable
      extend ActiveSupport::Concern

      included do
        has_metadata :name=>"migrationInfo", :type=>Hydra::Datastream::MigrationInfo, :autocreate=>true
        delegate :current_migration, :to=>:migrationInfo, :at=>[:current], :unique=>true
      end
    end
  end
end
