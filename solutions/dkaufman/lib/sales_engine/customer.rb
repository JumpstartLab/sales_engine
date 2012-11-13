$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib')).uniq!
require "sales_engine/database"
require "sales_engine/customer_record"

module SalesEngine
  class Customer
    include SalesEngine
    extend CustomerRecord
    attr_accessor :id, :first_name, :last_name, :created_at, :updated_at

    def initialize(id, first_name, last_name, created_at, updated_at)
      @id = id
      @first_name = first_name
      @last_name = last_name
      @created_at = created_at
      @updated_at = updated_at
    end

    def self.elements
      customers
    end

    def invoices
      Invoice.invoices.select { |invoice| invoice.customer_id == id }
    end

    def transactions
      Transaction.for_customer(id)
    end

    def has_pending_invoice?
      pending_invoices = false
      invoices.each do |invoice|
        pending_invoices = true if invoice.status == "pending"
      end
      return pending_invoices
    end

    def favorite_merchant
      merchant_map = Hash.new
      invoices.each do |invoice|
        merchant_id = invoice.merchant_id
        if merchant_map.key?(merchant_id)
          merchant_map[merchant_id] += 1
        else
          merchant_map[merchant_id] = 1
        end
      end

      unless merchant_map.empty?
        sorted_map = merchant_map.sort_by { |key, value| value }.reverse
        Merchant.find_by_id(sorted_map.first[0])
      end
    end
  end
end
