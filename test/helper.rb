require 'rubygems'
require 'bundler'

Bundler.setup

require 'active_record'
require 'active_record/fixtures'

require 'dase'

FIXTURES_PATH = File.join(File.dirname(__FILE__), 'fixtures')

ActiveRecord::Base.establish_connection(
    :adapter => defined?(JRUBY_VERSION) ? 'jdbcsqlite3' : 'sqlite3',
    :database => ':memory:'
)

dep = defined?(ActiveSupport::Dependencies) ? ActiveSupport::Dependencies : ::Dependencies
dep.autoload_paths.unshift FIXTURES_PATH

ActiveRecord::Migration.verbose = false
load File.join(FIXTURES_PATH, 'schema.rb')

ActiveRecord::FixtureSet.create_fixtures(FIXTURES_PATH, ActiveRecord::Base.connection.tables)

# require 'pry' rescue nil # use it when enabled in gemspec
require 'minitest/autorun'
