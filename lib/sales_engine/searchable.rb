require 'sales_engine'

module SalesEngine
  module Searchable
   def find_by_(attribute, input)
     collection.find{ |c| c.send(attribute) == input }
   end

   def find_all_by_(attribute, input)
     collection.find_all{ |c| c.send(attribute) == input }
   end

   def random
    rand(collection)
   end

  end
end