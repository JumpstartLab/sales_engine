require 'sales_engine/item'

class SalesEngine
  class Merchant
    attr_accessor :id

    def initialize(attributes)
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
      test_attrs = {:id => "100", :name => "Test Item", :description => "Test Item description", :unit_price => "12564", :merchant_id => "100", :created_at => "2012-02-26 20:56:56 UTC", :updated_at => "2012-02-26 20:56:56 UTC"}
      test_item = SalesEngine::Item.new(test_attrs)
      test_array = []
      test_array << test_item
    end

    # returns a collection of invoice instances associated with this merchant
    def invoices
    end
  end
end
