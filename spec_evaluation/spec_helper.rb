require 'bundler'

Bundler.require

RSpec.configure do |config|
  config.before(:suite) do
    SalesEngine.startup
  end
end
