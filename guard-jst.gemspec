# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'guard/jst/version'

Gem::Specification.new do |spec|
  spec.name          = "guard-jst"
  spec.version       = Guard::JstVersion::VERSION
  spec.authors       = ["Artem Nistratov"]
  spec.email         = ["anistratov@go-promo.ru"]
  spec.summary       = %q{Guard plugin for JST EJS templates.}
  spec.description   = %q{Simple Guard plugin for handle JST templates in EJS format.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'guard'
  spec.add_dependency 'ejs', '>= 1.1.1'

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "pry"
end
