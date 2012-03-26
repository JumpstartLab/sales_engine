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
      temp_invoices = SalesEngine::Database.instance.get_invoices
      correct_invoice = nil
      temp_invoices.each do |the_invoice|
        if the_invoice.id == @invoice_id
          correct_invoice = the_invoice
        end
      end
      correct_invoice
    end

    def item
      temp_items = SalesEngine::Database.instance.get_items
      correct_item = nil
      temp_items.each do |the_item|
          if the_item.id == @item_id
              correct_item = the_item
          end
      end
      return correct_item
    end

    # def customer
    # end
  end
end


