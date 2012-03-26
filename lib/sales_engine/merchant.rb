$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib')).uniq!
require "sales_engine"
require "sales_engine/invoice"

module SalesEngine
  class Merchant
    include SalesEngine
    attr_accessor :id, :name, :created_at, :updated_at

    def initialize(id, name, created_at, updated_at)
      @id = id.to_i
      @name = name
      @created_at = DateTime.parse(created_at)
      @updated_at = DateTime.parse(updated_at)
    end

    def invoices(date = nil)
      if date
        date = Date.parse(date)
        Database.invoices.select { |invoice| invoice.merchant_id == id && invoice.created_at.to_date == date }
      else
        Database.invoices.select { |invoice| invoice.merchant_id == id }
      end
    end

    def items
      Database.items.select { |item| item.merchant_id == id }
    end

    def self.elements
      Database.merchants
    end

    def invoice_items(date = nil)
      invoices(date).collect { |invoice| invoice.invoice_items }.flatten
    end

    def revenue(date = nil)
      revenue = 0
      invoice_items(date).each do |invoice_item|
        revenue += invoice_item.unit_price * invoice_item.quantity
      end
      revenue
    end

    def self.most_revenue(total_merchants)
      merchants = SalesEngine::Database.merchants
      merchants.sort_by!{ |merchant| merchant.revenue }.reverse!
      merchants[0,total_merchants]
    end
  end
end