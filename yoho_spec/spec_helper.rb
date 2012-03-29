require 'bundler'

<<<<<<< HEAD
Bundler.require
=======
Bundler.require(:default, :test)
>>>>>>> 546fc51806073375f968791bb26782f4ce8712c1

require 'sales_engine'
require 'date'

RSpec.configure do |config|
  config.before(:suite) do
    SalesEngine.startup
  end
end