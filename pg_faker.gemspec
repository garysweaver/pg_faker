# -*- encoding: utf-8 -*-  
$:.push File.expand_path("../lib", __FILE__)  
require "pg_faker/version" 

Gem::Specification.new do |s|
  s.name        = 'pg_faker'
  s.version     = PgFaker::VERSION
  s.authors     = ['Gary S. Weaver']
  s.email       = ['garysweaver@gmail.com']
  s.homepage    = 'https://github.com/garysweaver/pg_faker'
  s.summary     = %q{Fake postgres delays and errors for testing}
  s.description = %q{Allows you to specify one or all PG::Connection class methods to cause configurable delays and raise errors consistently or intermittently.}
  s.files = Dir['lib/**/*'] + ['Rakefile', 'README.md']
  s.license = 'MIT'
  # leaving commented, because it really isn't dependent on the pg gem, specifically
  # s.add_runtime_dependency 'pg'
end
