require './lib/sales_engine'

module Searchable
 def find(attribute, input)
   collection.find{ |c| c.send(attribute) == input }
 end
end
