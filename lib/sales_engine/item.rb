class SalesEngine
  class Item
    # attr_accessor :merchant

    def initialize(attributes)
      # puts attributes.inspect
      @id = attributes[:id]
      @name = attributes[:name]
      @description = attributes[:description]
      @unit_price = attributes[:unit_price]
      @merchant_id = attributes[:merchant_id]
      @created_at = attributes[:created_at]
      @updated_at = attributes[:updated_at]
    end

    # def self.random
    #   # return a random Merchant
    # end

    # # def self.find_by_X(match)
    # # end

    # # def self.find_all_by_X(match)
    # # end

    # def invoice_items
    # end

    # def merchant
    # end
  end
end
