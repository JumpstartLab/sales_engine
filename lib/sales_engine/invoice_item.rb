class SalesEngine
  class InvoiceItem

    attr_accessor :id, :item_id

    def initialize(attributes)
        @id = attributes[:id]
        @item_id = attributes[:item_id]
        @invoice_id = attributes[:invoice_id]
        @quantity = attributes[:quantity]
        @unit_price = attributes[:unit_price]
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

    # def transactions
    # end

    # def invoice
    # end

    def item
        temp_items = SalesEngine::Database.instance.get_items
        correct_item = nil
        temp_items.each do |the_item|
            if the_item.id == @item_id
                puts "#{the_item.id}...#{id}"
                correct_item = the_item
            end
        end
        return correct_item
    end

    # def customer
    # end
  end
end


