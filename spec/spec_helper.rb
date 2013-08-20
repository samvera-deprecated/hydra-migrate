$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

ENV["RAILS_ENV"] ||= "test"

require 'bundler/setup'
require 'rspec'
require 'rspec/autorun'

begin
  require 'simplecov'
  SimpleCov.start
rescue LoadError
end

require 'hydra/migrate'
