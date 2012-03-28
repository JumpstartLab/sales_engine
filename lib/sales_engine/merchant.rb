$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib')).uniq!
require "sales_engine"
require "sales_engine/invoice"
require "sales_engine/merchant_record"
require "sales_engine/invoice_item"

module SalesEngine
  class Merchant
    include SalesEngine
    extend MerchantRecord
    attr_accessor :id, :name, :created_at, :updated_at

    def initialize(id, name, created_at, updated_at)
      @id = id.to_i
      @name = name
      @created_at = DateTime.parse(created_at)
      @updated_at = DateTime.parse(updated_at)
    end

    def invoices(date = nil)
      if date
        Database.instance.invoices_by_merchant_for_date(id, date)
      else
        Database.instance.invoices_by_merchant(id)
      end
    end

    def items
      Database.instance.items.select { |item| item.merchant_id == id }
    end

    def customers
      Database.instance.customers_by_merchant(id)
    end

    def self.elements
      merchants
    end

    def paid_invoice_items(date = nil)
      if date
        InvoiceItem.successful_for_merchant_and_date(id, date)
      else 
        InvoiceItem.successful_for_merchant(id)
      end
    end

    def revenue(date = nil)
      revenue = 0
      paid_invoice_items(date).each do |invoice_item|
        revenue += invoice_item.unit_price * invoice_item.quantity
      end
      revenue
    end

    def self.most_revenue(total_merchants)
      merchants = Database.instance.merchants
      merchants.sort_by!{ |merchant| merchant.revenue }.reverse!
      merchants[0,total_merchants]
    end

    def customers_with_pending_invoices
      customers.select{ |customer| customer.has_pending_invoice? }
    end
  end
end
