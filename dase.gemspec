# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dase/version'

Gem::Specification.new do |gem|
  gem.name          = "dase"
  gem.version       = Dase::VERSION
  gem.authors       = ["Vladimir Yartsev"]
  gem.email         = ["vovayartsev@gmail.com"]
  gem.description   = %q{Dase gem creates includes_count_of method in ActiveRecord::Relation
                         to count associated records efficiently. See examples at https://github.com/vovayartsev/dase
                      }
  gem.summary       = %q{Provides includes_count_of method on ActiveRecord::Relation to count associated records efficiently}
  gem.homepage      = "https://github.com/vovayartsev/dase"

  gem.add_runtime_dependency "activerecord", "~> 3.2.0"
  gem.add_runtime_dependency "activesupport", "~> 3.2.0"
  gem.add_development_dependency 'shoulda'
  gem.add_development_dependency 'sqlite3', '~> 1.3.3'
  gem.add_development_dependency 'debugger'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
