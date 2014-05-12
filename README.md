# NOTICE: THIS PROJECT IS DEPRECATED

#### This project, and all others in [projecthydra-deprecated](http://github.com/projecthydra-deprecated), have been deprecated and are no longer actively maintained by the Hydra Project developer community. See the Hydra Project's main Github page at [projecthydra](http://github.com/projecthydra/) for projects that are actively maintained.

_Original README is below_

--------------------------

# Hydra::Migrate [![Build Status](https://travis-ci.org/projecthydra/hydra-migrate.png?branch=master)](https://travis-ci.org/projecthydra/hydra-migrate)

Simple migrations for Hydra models

## Installation

Add this line to your application's Gemfile:

    gem 'hydra-migrate', :require => false

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hydra-migrate

## Usage

### app/models/my_model.rb

    class MyModel < ActiveFedora::Base
      include Hydra::ModelMixins::Migratable
      # ... other model code here ...
    end

### Magic class naming: db/hydra/my_model_migration.rb

    class MyModelMigration < Hydra::Migrate::Migration
      migrate nil => 1 do |object,version,dispatcher|
        # Do stuff to object to get it from unknown version to v1
      end

      migrate 1 => 2 do |object,version,dispatcher|
        # Do stuff to object to get it from v1 to v2
      end
    end

### Manual class naming: db/hydra/my_explicit_model_migration.rb

    class MyExplicitModelMigration < Hydra::Migrate::Migration
      migrates MyModel

      migrate nil => 1 do |object,version,dispatcher|
        # Do stuff to object to get it from unknown version to v1
      end

      migrate 1 => 2 do |object,version,dispatcher|
        # Do stuff to object to get it from v1 to v2
      end
    end

### Run the migration

    # Migrate everything that can be migrated
    $ rake hydra:migrate

    # Migrate one particular class of objects
    $ rake hydra:migrate models=MyModel

    # Target a specific version
    $ rake hydra:migrate to=3

## Todo

* Reversible migrations (rollback)
* Improved rake task(s):
    * Migrate specific object, not entire model class

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md)
