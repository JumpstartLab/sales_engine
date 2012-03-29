$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib')).uniq!
require "sales_engine"
require "sales_engine/invoice"
require "sales_engine/merchant_record"
require "sales_engine/invoice_item"
require "bigdecimal"

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
        Invoice.for_merchant_and_date(id, date)
      else
        Invoice.for_merchant(id)
      end
    end

    def items
      Item.items.select { |item| item.merchant_id == id }
    end

    def customers
      Customer.for_merchant(id)
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
      BigDecimal.new(revenue.to_s).round(2)
    end

    def self.revenue(date)
      result = 0
      merchants.each { |merchant| result += merchant.revenue(date) } 
      BigDecimal.new(result.to_s).round(2)
    end

    def self.most_revenue(total_merchants)
      results = merchants.sort_by{ |merchant| merchant.revenue }.reverse!
      results[0,total_merchants]
    end

    def self.most_items(total_merchants)
      results = merchants.sort_by do |merchant| 
        merchant.paid_invoice_items.length 
      end.reverse!
      results[0,total_merchants]
    end

    #def customers_with_pending_invoices
      #customers.select{ |customer| customer.has_pending_invoice? }
    #end

    def favorite_customer
      find_favorite_customer(id)
    end
  end
end
