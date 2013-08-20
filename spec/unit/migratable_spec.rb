require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Hydra::ModelMixins::Migratable do
  before :all do
    class TestClass < ActiveFedora::Base
      include Hydra::ModelMixins::Migratable
    end
  end

  after :all do
    Object.send(:remove_const, :TestClass)
  end

  subject {TestClass.new}

  it "should have a migrationInfo datastream" do
    subject.datastreams['migrationInfo'].should be_a(Hydra::Datastream::MigrationInfo)
  end
end