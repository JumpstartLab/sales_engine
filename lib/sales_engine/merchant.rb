$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib')).uniq!
require "sales_engine"
require "sales_engine/invoice"

module SalesEngine
  class Merchant
    include SalesEngine
    attr_accessor :id, :name, :created_at, :updated_at

    def initialize(id, name, created_at, updated_at)
      @id = id
      @name = name
      @created_at = created_at
      @updated_at = updated_at
    end

    def invoices
      Database.invoices.select { |invoice| invoice.merchant_id == id }
    end

    def items
      Database.items.select { |item| item.merchant_id == id }
    end

    def self.elements
      Database.merchants
    end

    def invoice_items
      invoices.collect { |invoice| invoice.invoice_items }.flatten
    end

    def revenue
      revenue = 0
      invoice_items.each do |invoice_item|
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