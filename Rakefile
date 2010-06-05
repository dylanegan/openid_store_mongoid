begin
  require ::File.expand_path('.bundle/environment', __FILE__)
rescue LoadError
  require "rubygems"
  require "bundler"
  Bundler.setup
end

Bundler.require(:default, :rake)

Dir["tasks/*.rake"].sort.each { |file| load file }
