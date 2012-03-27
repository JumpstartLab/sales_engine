require 'bundler'

Bundler.require

require 'date'

RSpec.configure do |config|
  config.before(:suite) do
    SalesEngine.startup
  end
end
