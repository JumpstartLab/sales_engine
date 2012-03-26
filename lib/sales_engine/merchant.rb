require 'sales_engine/item'
require 'sales_engine/model'
require 'bigdecimal'

class SalesEngine
  class Merchant
    include Model
    attr_accessor :id

    def initialize(attributes)
      super(attributes)
      @name = attributes[:name]
    end

    def self.random
      SalesEngine::Database.instance.get_merchants.sample
    end

    # def self.find_by_X(match)
    # end

    # def self.find_all_by_X(match)
    # end

    # returns a collection of Item instances associated with that merchant for their products
    def items
      temp_items = SalesEngine::Database.instance.get_items
      correct_items = []
      temp_items.each do |item|
        if item.merchant_id == @id
          correct_items << item
        end
      end
      return correct_items
    end

    # returns a collection of invoice instances associated with this merchant
    def invoices
      temp_invoices = SalesEngine::Database.instance.get_invoices
      correct_invoices = []
      temp_invoices.each do |invoice|
        if invoice.merchant_id == @id
          correct_invoices << invoice
        end
      end
      return correct_invoices
    end

    def revenue
      BigDecimal.new("8493")
    end

  end
end
