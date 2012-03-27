require 'sales_engine/model'

class SalesEngine
  class InvoiceItem
    include Model

    attr_accessor :id, :item_id, :invoice_id

    def initialize(attributes)
        super
        @item_id = attributes[:item_id]
        @invoice_id = attributes[:invoice_id]
        @quantity = attributes[:quantity]
        @unit_price = attributes[:unit_price]
    end

    # def self.random
    #   # return a random Merchant
    # end

    # # def self.find_by_X(match)
    # # end

    # # def self.find_all_by_X(match)
    # # end

    # def transactions
    # end

    def invoice
      SalesEngine::Database.instance.invoices.find do |invoice|
        invoice.id == @invoice_id
      end
    end

    def item
      SalesEngine::Database.instance.items.find do |item|
        item.id == @item_id
      end
    end

    # def customer
    # end
  end
end


