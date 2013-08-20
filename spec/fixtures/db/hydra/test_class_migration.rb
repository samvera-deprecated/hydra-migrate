class TestClassMigration < Hydra::Migrate::Migration
  migrate(nil => 1) { |obj,version,migrator|
    obj.myMetadata.migrated = 'yep'
  }

  migrate(1 => 2) { |obj,version,migrator|
    obj.myMetadata.migrated = obj.myMetadata.migrated.first + ', YEP!'
  }
end
