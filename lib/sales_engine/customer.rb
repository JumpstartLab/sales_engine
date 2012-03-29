require 'sales_engine/model'

class SalesEngine
  class Customer

    ATTRIBUTES = ["id", "created_at", "updated_at", "first_name", "last_name"]
    def self.finder_attributes
      ATTRIBUTES
    end

    include Model
    attr_accessor :id, :first_name, :last_name, :created_at, :updated_at

    def initialize(attributes)
      super
      @first_name = attributes[:first_name]
      @last_name = attributes[:last_name]
    end

    def invoices
      @invoices || SalesEngine::Invoice.find_all_by_customer_id(@id)
    end

    def invoices=(input)
      @invoices = input
    end

    def transactions
      correct_transactions = invoices.collect do |invoice|
        invoice.transactions
      end
      correct_transactions.flatten
    end

    def favorite_merchant
      grouped_by_merchant = invoices.group_by{|invoice| invoice.merchant}
      sorted_and_grouped_by_merchant = grouped_by_merchant.sort_by{|merchant, invoices| invoices.count }
      merchant_and_invoices = sorted_and_grouped_by_merchant.last
      merchant = merchant_and_invoices.first
    end

    def self.add_to_db(cust)
      if self.find_by_id(cust.id) == nil
        SalesEngine::Database.instance.customers << cust
      end
    end
  end
end
