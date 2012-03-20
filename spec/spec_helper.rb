require 'simplecov'
SimpleCove.start do
  add_filter "/spec/"
end

require "./*.rb$"