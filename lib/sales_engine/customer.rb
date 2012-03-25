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

    def update
      @invoices ||= calc_invoices
      @transactions ||= calc_transactions
      @successful_transactions ||= calc_successful_transactions
      @favorite_merchant ||= calc_favorite_merchant
    end

    def transactions
      @transactions ||= calc_transactions
    end

    def invoices
      @invoices ||= calc_invoices
    end

    def favorite_merchant
      @favorite_merchant ||= calc_favorite_merchant
    end

    def successful_transactions
      @successful_transactions ||= calc_successful_transactions
    end

    def calc_invoices
      @invoices = Invoice.find_all_by_customer_id(self.id)
    end

    def calc_transactions
      trans_actions = self.invoices.collect do |invoice|
        invoice.transactions
      end
      @transactions = trans_actions.flatten.uniq
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
          @favorite_merchant = Merchant.find_by_id(fav_merchant_id)
        end
      end
    end

    def calc_successful_transactions
      @successful_transactions = self.transactions.select do |transaction|
        transaction.successful?
      end
    end

  end
end