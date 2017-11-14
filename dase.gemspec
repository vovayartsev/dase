# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dase/version'

Gem::Specification.new do |gem|
  gem.name          = "dase"
  gem.version       = Dase::VERSION
  gem.authors       = ["Vladimir Yartsev"]
  gem.licenses      = ["MIT"]
  gem.email         = ["vovayartsev@gmail.com"]
  gem.description   = %q{includes_count_of method on ActiveRecord::Relation to solve N+1 query problem when counting associated records }
  gem.summary       = %q{Provides includes_count_of method on ActiveRecord::Relation to count associated records efficiently}
  gem.homepage      = "https://github.com/vovayartsev/dase"

  gem.add_runtime_dependency "activesupport", "~> 4.2", '>= 4.2.10' 

  if defined? JRUBY_VERSION
    gem.add_development_dependency 'activerecord-jdbcsqlite3-adapter'
  else
    gem.add_runtime_dependency 'activerecord', '~> 4.2', '>= 4.2.10'
    gem.add_development_dependency 'sqlite3', '~> 1.3'
  end

  # gem.add_development_dependency 'pry'
  gem.add_development_dependency 'rake', '~> 10.3'
  gem.add_development_dependency 'rspec-core', '~> 3.1'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
