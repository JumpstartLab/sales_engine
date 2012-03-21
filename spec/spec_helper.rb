$LOAD_PATH << './'
$LOAD_PATH << './lib'
$LOAD_PATH << './data'
require 'simplecov'
SimpleCov.start do
  add_filter "/spec/"
end