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
        SalesEngine::Database.instance.invoices_by_merchant_for_date(id, date)
      else
        SalesEngine::Database.instance.invoices_by_merchant(id)
      end
    end

    def items
      SalesEngine::Database.instance.items.select { |item| item.merchant_id == id }
    end

    def customers
      SalesEngine::Database.instance.customers_by_merchant(id)
    end

    def self.elements
      SalesEngine::Database.instance.merchants
    end

    def invoice_items(date = nil)
      if date
        SalesEngine::Database.instance.invoice_items_by_merchant_for_date(id, date)
      else 
        SalesEngine::Database.instance.invoice_items_by_merchant(id)
      end
    end

    def revenue(date = nil)
      revenue = 0
      invoice_items(date).each do |invoice_item|
        revenue += invoice_item.unit_price * invoice_item.quantity
      end
      revenue
    end

    def self.most_revenue(total_merchants)
      merchants = SalesEngine::Database.instance.merchants
      merchants.sort_by!{ |merchant| merchant.revenue }.reverse!
      merchants[0,total_merchants]
    end
  end
end
