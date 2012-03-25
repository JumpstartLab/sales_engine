module SalesEngine
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

    CUSTOMER_ATTS.each do |att|
      define_singleton_method ("find_by_" + att).to_sym do |param|
        SalesEngine::Database.instance.customer_list.detect do |customer|
          customer.send(att.to_sym).to_s.downcase == param.to_s.downcase
        end
      end
    end

    CUSTOMER_ATTS.each do |att|
      define_singleton_method ("find_all_by_" + att).to_sym do |param|
        SalesEngine::Database.instance.customer_list.select do |customer| 
          customer if customer.send(att.to_sym).to_s.downcase == param.to_s.downcase
        end
      end
    end

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

    def favorite_merchant
      successful_transactions = self.transactions.select do |transaction|
        transaction if transaction.is_successful?
      end

      successful_invoices = successful_transactions.collect do |transaction|
        SalesEngine::Invoice.find_by_id(transaction.invoice_id)
      end

      # debugger
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