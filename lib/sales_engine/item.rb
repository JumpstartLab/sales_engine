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
        date = Date.parse(invoice_item.invoice.created_at)
        if days.has_key?(date)
          days[date] += invoice_item.quantity
        else
          days[date] = invoice_item.quantity
        end
      end
      puts days
      days
    end

    def best_day
      unless quantity_by_day.empty?
        date = quantity_by_day.sort_by{ |date, quantity| quantity }.last[0]
      end
    end
  end
end
