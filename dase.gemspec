# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dase/version'

Gem::Specification.new do |gem|
  gem.name          = "dase"
  gem.version       = Dase::VERSION
  gem.authors       = ["Vladimir Yartsev"]
  gem.email         = ["vovayartsev@gmail.com"]
  gem.description   = %q{A solution for N+1 querying problem in Active Record associated records counting}
  gem.summary       = %q{Really fast associated records counting}
  gem.homepage      = "https://github.com/vovayartsev"

  gem.add_runtime_dependency "activerecord", "~> 3.2.0"
  gem.add_runtime_dependency "activesupport", "~> 3.2.0"
  gem.add_development_dependency 'shoulda'
  gem.add_development_dependency 'sqlite3', '~> 1.3.3'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
