# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'penelope/core/version'

Gem::Specification.new do |spec|
  spec.name          = "penelope-core"
  spec.version       = Penelope::Core::VERSION
  spec.authors       = ["Jonathan Gnagy"]
  spec.email         = ["jonathan.gnagy@gmail.com"]

  spec.summary       = %q{Penelope Core library}
  spec.homepage      = 'https://github.com/jgnagy/penelope-core'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.metadata['yard.run']  = 'yri'
  spec.platform              = %q{java}
  spec.required_ruby_version = '~> 2.0'

  spec.add_runtime_dependency 'data_mapper', '~> 1.2'
  spec.add_runtime_dependency "dm-mysql-adapter", '~> 1.2'
  spec.add_runtime_dependency 'do_jdbc', '~> 0.10'
  spec.add_runtime_dependency 'jdbc-mysql', '~> 5.1'
  spec.add_runtime_dependency 'rjgit', '~> 4.2'
  spec.add_runtime_dependency 'resque', '~> 1.26'

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.1"
  spec.add_development_dependency 'rubocop', '~> 0.35'
  spec.add_development_dependency 'yard',    '~> 0.8'
  spec.add_development_dependency 'travis', '~> 1.8'
  spec.add_development_dependency 'simplecov'
end
