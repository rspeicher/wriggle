# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "wriggle/version"

Gem::Specification.new do |s|
  s.name        = "wriggle"
  s.version     = Wriggle::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Robert Speicher"]
  s.email       = ["rspeicher@gmail.com"]
  s.homepage    = "http://github.com/tsigo/wriggle"
  s.summary     = %q{A simple directory crawler DSL}
  s.description = %q{A simple directory crawler DSL.}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]

  s.add_development_dependency "rspec", "~> 2.5"
  s.add_development_dependency "yard", "~> 0.6"
end
