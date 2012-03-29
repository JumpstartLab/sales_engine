require 'sales_engine/model'
require 'date'

class SalesEngine
  class Item
    ATTRIBUTES = %w(id created_at updated_at name
      description unit_price merchant_id)

    attr_accessor :merchant_id, :id, :item_id, :name, :description,
      :unit_price, :created_at, :updated_at

    def initialize(attributes)
      super
      @name = attributes[:name]
      @description = attributes[:description]
      @unit_price = BigDecimal.new(attributes[:unit_price]).round(2)
      @merchant_id = attributes[:merchant_id].to_i
    end

    def self.finder_attributes
      ATTRIBUTES
    end

    include Model

    def invoice_items     
      @invoice_items ||= SalesEngine::InvoiceItem.find_all_by_item_id(@id)
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
      sorted_days.first.first.to_s
    end

    def item_quantity_per_day
      item_quantities = {}
      invoice_items.each do |ii|
        date = (Date.parse(ii.updated_at)).strftime("%Y-%m-%d")
        item_quantities[date] ||= 0
        item_quantities[date] += ii.quantity
      end
      item_quantities
    end

    def self.most_revenue(x)
      rnkd_items_by_rev = SalesEngine::Database.instance.items.sort do |a,b|
        b.revenue <=> a.revenue
      end
      rnkd_items_by_rev.pop(x)
    end

    def self.most_items(x)
      ranked_items_by_count = SalesEngine::Database.instance.items.sort do |a,b|
        b.sales_count <=> a.sales_count
      end
    end

    def sales_count
      @sales_count ||= invoice_items.inject(0) do |sum, element|
        sum + element.quantity
      end
    end

    def sales_count=(input)
      @sales_count = input
    end

    def revenue=(input)
      @revenue = input
    end

    def revenue
      result = invoice_items.inject(0) {|sum, element| sum + element.total }
      b = BigDecimal.new(result) / 100
      @revenue || b
    end
  end
end
