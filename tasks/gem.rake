require 'rubygems/package_task'
require File.dirname(__FILE__) + '/../lib/openid_store_mongoid/version'

GEM_SPEC = Gem::Specification.new do |s|
  s.name        = "openid_store_mongoid"
  s.version     = OpenIDStoreMongoid::VERSION
  s.platform    = Gem::Platform::RUBY

  s.summary     = 'Storing your OpenIDs in your Mongos.'
  s.description = "Why does a squirrel swim on its back?\nTo keep its nuts dry"

  s.required_ruby_version = ">= 1.8.6"
  s.required_rubygems_version = ">= 1.3.5"

  # dependencies
  s.add_dependency  'rake', '>= 0.8.3', '< 0.9'
  bundle = Bundler::Definition.from_gemfile("Gemfile")
  bundle.dependencies.select { |d| !d.groups.include?(:development) and !d.groups.include?(:rake) }.
         each { |d| s.add_dependency(d.name, d.requirement.to_s) }

  bundle.dependencies.select { |d| d.groups.include?(:development) }.
         each { |d| s.add_development_dependency(d.name, d.requirement.to_s) }

  s.files = FileList["lib/**/*.rb", "test/**/*.rb", "tasks/**/*.rake", "Rakefile", "README.md"]

  s.bindir      = 'bin'
  s.executables = []

  s.require_path = 'lib'

  s.extra_rdoc_files = %w(README.md)

  s.homepage          = 'http://github.com/abcde/openid_store_mongoid'
  s.licenses          = ['MIT']

  s.author      = 'Dylan Egan'
  s.email       = 'dylanegan@gmail.com'
end

gem_package = Gem::PackageTask.new(GEM_SPEC) do |pkg|
  pkg.need_tar = false
  pkg.need_zip = false
end
