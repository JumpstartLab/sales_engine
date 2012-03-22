require 'sales_engine/item'

class SalesEngine
  class Merchant
    # attr_accessor :items, :invoices

    def initialize(attributes)
      # puts attributes.inspect
      @id = attributes[:id]
      @name = attributes[:name]
      @created_at = attributes[:created_at]
      @updated_at = attributes[:updated_at]
    end

    def self.random
      # Database.get_a_random_merchant
    end

    # def self.find_by_X(match)
    # end

    # def self.find_all_by_X(match)
    # end

    # returns a collection of Item instances associated with that merchant for their products
    def items
      # Get merchant ID for this merchant
      # Ask the 'items' db for a list of associated items with this merchant_ID
    end

    # returns a collection of invoice instances associated with this merchant
    def invoices
    end
  end
end
