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
      self.id = attributes[:id].to_i
      self.first_name = attributes[:first_name]
      self.last_name = attributes[:last_name]
      self.created_at = attributes[:created_at]
      self.updated_at = attributes[:updated_at]

      SalesEngine::Database.instance.customer_list << self
      SalesEngine::Database.instance.customer_id_hash[ self.id ] = self
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
        inv_trans = SalesEngine::Transaction.find_all_by_invoice_id(invoice.id)
        trans_results.concat( inv_trans )
      end
      trans_results
    end

    def successful_invoices
      results = invoices.select { |inv| inv if inv.is_successful? }
    end

    def merchant_paid_invoice_count
      paid_invoice_count = { }

      successful_invoices.each do |invoice|
        paid_invoice_count[ invoice.merchant_id.to_sym ] ||= 0
        paid_invoice_count[ invoice.merchant_id.to_sym ] += 1
      end
      paid_invoice_count
    end

    def favorite_merchant
      merchant_data_max = merchant_paid_invoice_count.max_by{ |k, v| v }
      return nil if merchant_data_max.nil?
      SalesEngine::Merchant.find_by_id(merchant_data_max.first)
    end

  end
end