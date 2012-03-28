require 'sales_engine/model'
require 'date'

class SalesEngine
  class Item
    ATTRIBUTES = %w(id created_at updated_at name description unit_price merchant_id)

    attr_accessor :merchant_id, :id, :item_id

    def initialize(attributes)
      super
      @name = attributes[:name]
      @description = attributes[:description]
      @unit_price = attributes[:unit_price]
      @merchant_id = attributes[:merchant_id]
    end

    def self.finder_attributes
      ATTRIBUTES
    end

    include Model

    def invoice_items     
      @invoice_items || SalesEngine::InvoiceItem.find_all_by_item_id(@id)
    end

    def invoice_items=(input)
      @invoice_items = input
    end

    def merchant
      SalesEngine::Merchant.find_by_id(@merchant_id)
    end

    # returns the date with the most sales for 
    # the given item using the invoice date
    def best_day
      sorted_days = item_quantity_per_day.sort_by{|date, count| -count}
      sorted_days.first.first
    end

    def item_quantity_per_day
      item_quantities = {}
      invoice_items.each do |ii|
        date = ii.updated_at.strftime("%Y-%m-%d")
        item_quantities[date] ||= 0
        item_quantities[date] += ii.quantity
      end
      item_quantities
    end

    def self.most_revenue(x)
      ranked_items = SalesEngine::Database.instance.all("items").pop(x)
    end
  end
end
