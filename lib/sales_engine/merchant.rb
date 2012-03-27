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
      SalesEngine::Database.instance.merchants.sample
    end

    # def self.find_by_X(match)
    # end

    # def self.find_all_by_X(match)
    # end

    # returns a collection of Item instances associated with that merchant for their products
    def items
      SalesEngine::Database.instance.items.select do |item|
        item.merchant_id == @id
      end
    end

    # returns a collection of invoice instances associated with this merchant
    def invoices
      SalesEngine::Database.instance.invoices.select do |invoice|
        invoice.merchant_id == @id
      end
    end

    def revenue
      invoices
      BigDecimal.new("8493")
    end

  end
end
