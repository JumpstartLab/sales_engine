$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib')).uniq!
require "sales_engine"
require "sales_engine/database"
require "sales_engine/item_record"

module SalesEngine
  class Item
    include SalesEngine
    extend ItemRecord
    attr_accessor :id, :name, :description, :unit_price,
    :merchant_id, :created_at, :updated_at

    def initialize(id, name, description, unit_price, merchant_id, created_at, updated_at) 
      @id = id
      @name = name
      @description = description
      @unit_price = unit_price
      @merchant_id = merchant_id
      @created_at = created_at
      @updated_at = updated_at
    end               

    def self.elements
      items
    end

    def merchant
      Merchant.merchants.find { |merchant| merchant.id == merchant_id}
    end

    def invoice_items
      InvoiceItem.for_item(id)
    end

    def revenue
      total = 0
      invoice_items.each do |invoice_item|
        total += invoice_item.unit_price * invoice_item.quantity
      end
      total
    end

    def quantity
      total = 0
      invoice_items.each do |invoice_item|
        total += invoice_item.quantity
      end
      total
    end

    def quantity_sold
      total = 0
      InvoiceItem.invoice_items_sold_for(id).each do |invoice_item|
        total += invoice_item.quantity
      end
      total
    end

    def quantity_by_day
      days = {}
      invoice_items.each do |invoice_item|
        date = invoice_item.created_at.to_date
        if days.has_key?(date)
          days[date] += invoice_item.quantity
        else
          days[date] = invoice_item.quantity
        end
      end
      days
    end

    def best_day
      unless quantity_by_day.empty?
        quantity_by_day.sort_by{ |date, quantity| quantity }.last[0]
      end
    end

    def self.most_revenue(total_items)
      items_array = items
      items_array.sort_by!{ |item| item.revenue }.reverse!
      items_array[0,total_items]
    end

    def self.most_items(total_items)
      items_array = items
      items_array.sort_by!{ |item| item.quantity_sold }.reverse!
      items_array[0,total_items]
    end
  end
end
