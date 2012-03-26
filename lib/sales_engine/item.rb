require 'sales_engine/model'

class SalesEngine
  class Item
    include Model
    attr_accessor :merchant_id, :id, :item_id

    def initialize(attributes)
      super
      @name = attributes[:name]
      @description = attributes[:description]
      @unit_price = attributes[:unit_price]
      @merchant_id = attributes[:merchant_id]
    end

    # def self.random
    #   # return a random Merchant
    # end

    # # def self.find_by_X(match)
    # # end

    # # def self.find_all_by_X(match)
    # # end

    def invoice_items
      temp_invoice_items = SalesEngine::Database.instance.get_invoice_items
      correct_invoice_items = []
      temp_invoice_items.each do |invoice_item|
        if invoice_item.item_id == @id
          correct_invoice_items << invoice_item
        end
      end
      return correct_invoice_items
    end

    # def merchant
    # end
  end
end
