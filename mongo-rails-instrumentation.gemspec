# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "mongo/rails/instrumentation/version"

Gem::Specification.new do |s|
  s.name        = "mongo-rails-instrumentation"
  s.version     = Mongo::Rails::Instrumentation::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Tom Ward"]
  s.email       = ["tom@popdog.net"]
  s.homepage    = "http://tomafro.net"
  s.summary     = %q{Records time spent in mongo and adds to request logs}
  s.description = %q{Records time spent in mongo and adds to request logs}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'rails', '~>3.0.0'
end
