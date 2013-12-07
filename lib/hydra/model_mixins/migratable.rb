module Hydra
  module ModelMixins
    module Migratable
      extend ActiveSupport::Concern

      included do
        has_metadata :name=>"migrationInfo", :type=>Hydra::Datastream::MigrationInfo, :autocreate=>true
        has_attributes :current_migration, :datastream=>:migrationInfo, :at=>[:current], :multiple=>false
      end
    end
  end
end
