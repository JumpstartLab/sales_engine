require 'class_methods'
require 'merchant'
require 'invoice'
require "date"
module SalesEngine
  class Customer
    ATTRIBUTES = [:id, :first_name, :last_name, :created_at, :updated_at]
    attr_reader :invoices, :transactions, :favorite_merchant,
                :successful_transactions
    extend SearchMethods
    include AccessorBuilder

    def initialize (attributes = {})
      define_attributes(attributes)
      calc_invoices
      calc_transactions
      calc_successful_transactions
      calc_favorite_merchant
    end

    def calc_invoices
      @invoices = Invoice.find_all_by_customer_id(self.id)
    end

    def calc_transactions
      transactions = self.invoices.collect do |invoice|
        invoice.transactions
      end
      @transactions = transactions.flatten
    end

    def calc_favorite_merchant
      if successful_transactions.any?
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
          @merchant = Merchant.find_by_id(fav_merchant_id)
        end
      end
    end

    def calc_successful_transactions
      @successful_transactions = transactions.select do |transaction|
        transaction.successful?
      end
    end

  end
end