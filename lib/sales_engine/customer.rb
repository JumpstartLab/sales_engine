require 'class_methods'
require 'merchant'
require 'invoice'
require "date"
module SalesEngine
  class Customer
    ATTRIBUTES = [:id, :first_name, :last_name, :created_at, :updated_at]
    extend SearchMethods
    include AccessorBuilder

    def initialize (attributes = {})
      define_attributes(attributes)
    end

    def invoices
      Invoice.find_all_by_customer_id(self.id)
    end

    def transactions
      all_invoices = self.invoices
      transactions = all_invoices.collect do |invoice|
        invoice.transactions
      end
      transactions.flatten
    end

    def favorite_merchant
      successful = successful_transactions
      merchant_hash = Hash.new() {|hash, key| hash[key] = 0}
      successful.each do |transaction|
        merchant_hash[transaction.invoice.merchant_id] += 1
      end
      sorted_array = merchant_hash.sort_by do |key, value|
        value
      end
      if sorted_array.any?
        fav_merchant_id = sorted_array.first[0]
        Merchant.find_by_id(fav_merchant_id)
      else
        nil
      end
    end

    def successful_transactions
      self.transactions.select {|transaction| transaction.successful? }
    end

  end
end