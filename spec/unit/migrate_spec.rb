require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Hydra::Migrate do
  before :all do
    class TestClass < ActiveFedora::Base
      include Hydra::ModelMixins::Migratable
      has_metadata name: 'myMetadata', :type => ActiveFedora::SimpleDatastream do |d|
        d.field :migrated, :string
      end

      def save
        true
      end
    end
  end

  after :each do
    # Undefine all migration classes
    ObjectSpace.each_object(Hydra::Migrate::Migration).to_a.collect { |obj| 
      obj.class.name.to_sym 
    }.uniq.each { |klass| 
      begin
        Object.send(:remove_const, klass)
      rescue NameError
      end
    }
  end

  after :all do
    Object.send(:remove_const, :TestClass)
  end

  let!(:migrator) {Hydra::Migrate::Dispatcher.new}
  subject {TestClass.new}

  describe "no migrations defined" do
    it "should have a nil migration version" do
      expect(subject.current_migration).to be_blank
    end

    it "should not be able to migrate" do
      expect(migrator.can_migrate?(subject)).to be_false
    end
  end

  describe "TestClassMigration" do
    before :each do
      migrator.load_migrations(File.expand_path('../../fixtures/db',__FILE__))
    end

    before :each do
      @migration = TestClassMigration.new(migrator)
    end

    it "should target the right class" do
      TestClassMigration.target_class.should eq(TestClass)
    end

    it "should be able to migrate" do
      expect(subject.current_migration).to be_blank
      expect(subject.myMetadata.migrated).to be_blank
      expect(migrator.can_migrate?(subject)).to be_true
      expect(migrator.can_migrate?(subject, :to=>1)).to be_true
      expect(migrator.can_migrate?(subject, :to=>2)).to be_false
    end

    describe "migrate" do
      it "should perform migrations" do
        migrator.migrate!(subject)
        expect(subject.myMetadata.migrated).to eq(['yep'])
        expect(subject.current_migration).to eq('1')

        migrator.migrate!(subject)
        expect(subject.myMetadata.migrated).to eq(['yep, YEP!'])
        expect(subject.current_migration).to eq('2')
      end

      it "should migrate multiple objects" do
        subject_2 = subject.class.new
        expect(subject.current_migration).to be_blank
        expect(subject.myMetadata.migrated).to be_blank
        expect(subject_2.current_migration).to be_blank
        expect(subject_2.myMetadata.migrated).to be_blank

        migrator.migrate!([subject, subject_2], :to=>1)
        expect(subject.myMetadata.migrated).to eq(['yep'])
        expect(subject.current_migration).to eq('1')
        expect(subject_2.myMetadata.migrated).to eq(['yep'])
        expect(subject_2.current_migration).to eq('1')
      end
    end
  end

  describe "ExplicitTestClassMigration" do
    before :all do
      class ExplicitTestClassMigration < Hydra::Migrate::Migration
        migrates TestClass
      end
    end

    after :all do
      Object.send(:remove_const, :ExplicitTestClassMigration)
    end

    it "should target the right class" do
      expect(ExplicitTestClassMigration.target_class).to eq(TestClass)
    end
  end

  describe "IncorrectTestClassMigration" do
    after :each do
      Object.send(:remove_const, :IncorrectTestClassMigration)
    end

    it "should require a migratable class" do
      expect(lambda {
        class IncorrectTestClassMigration < Hydra::Migrate::Migration
          migrates Object
        end
      }).to raise_error(TypeError)
    end

    it "should require a correctly-formed migration spec" do
      class IncorrectTestClassMigration < Hydra::Migrate::Migration
        migrates TestClass
      end
      expect { IncorrectTestClassMigration.migrate { } }.to raise_error(ArgumentError)
      expect { IncorrectTestClassMigration.migrate(2) { } }.to raise_error(ArgumentError)
      expect { IncorrectTestClassMigration.migrate(1=>2) { } }.not_to raise_error()
      expect { IncorrectTestClassMigration.migrate(1=>2,2=>3) { } }.to raise_error(ArgumentError)
    end
  end
end
