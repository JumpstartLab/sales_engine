module SalesEngine
  require 'sales_engine/dynamic_finder'
  class Customer
    attr_accessor :id, :first_name, :last_name, :created_at, :updated_at

    CUSTOMER_ATTS = [
     "id",
     "first_name",
     "last_name",
     "created_at",
     "updated_at"
     ]

    def initialize(attributes)
      self.id = attributes[:id]
      self.first_name = attributes[:first_name]
      self.last_name = attributes[:last_name]
      self.created_at = attributes[:created_at]
      self.updated_at = attributes[:updated_at]
    end

    def self.attributes_for_finders
      CUSTOMER_ATTS
    end

    extend SalesEngine::DynamicFinder

    def invoices
      SalesEngine::Invoice.find_all_by_customer_id(self.id)
    end

    def transactions
      trans_results = Array.new
      self.invoices.each do |invoice|
        trans_results.concat( SalesEngine::Transaction.find_all_by_invoice_id(invoice.id) )
      end
      trans_results
    end

    def successful_invoices
      results = invoices.select { |inv| inv if inv.is_successful? }
    end

    def favorite_merchant
      merchant_data = { }

      successful_invoices.each do |invoice|
        merchant_data[ invoice.merchant_id.to_sym ] ||= 0
        merchant_data[ invoice.merchant_id.to_sym ] += 1
      end

      merchant_data_max = merchant_data.max_by{ |k, v| v }
      return nil if merchant_data_max.nil?
      SalesEngine::Merchant.find_by_id(merchant_data_max.first)   
    end

  end
end