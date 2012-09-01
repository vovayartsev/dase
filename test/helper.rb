# borrowed from https://github.com/ernie/meta_where/blob/master/test/helper.rb
# with slight modifications
require "rubygems"
require "bundler"
Bundler.setup
require 'test/unit'
require 'shoulda'
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

ActiveRecord::Base.silence do
  ActiveRecord::Migration.verbose = false
  load File.join(FIXTURES_PATH, 'schema.rb')
end

ActiveRecord::Fixtures.create_fixtures(FIXTURES_PATH, ActiveRecord::Base.connection.tables)

class Test::Unit::TestCase
end