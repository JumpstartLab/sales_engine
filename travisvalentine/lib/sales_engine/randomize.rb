require 'sales_engine'

module SalesEngine
  module Randomize
    def random
      collection.shuffle.first
    end
  end
end

