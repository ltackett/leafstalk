# -*- encoding: utf-8 -*-
require File.expand_path('../lib/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = "leafstalk"
  s.version     = Leafstalk::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Lorin Tackett"]
  s.email       = ["lorin.tackett@gmail.com"]
  s.homepage    = "http://github.com/ltackett/leafstalk"
  s.summary     = "Useful jQuery plugins and Sass mixins for Rails 3.1"
  s.description = "This gem adds a bunch of useful jQuery plugins and Sass mixins to your Rails 3.1 project via the asset pipeline."

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project         = "leafstalk"

  s.add_dependency "rails",   "~> 3.1"

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").select{|f| f =~ /^bin/}
  s.require_path = 'lib'
end