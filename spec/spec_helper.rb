require 'simplecov'
SimpleCov.start do
  add_filter "/spec/"
end

require './customer'
require './data_loader'