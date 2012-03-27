require 'sales_engine/model'

class SalesEngine
  class Customer
    include Model
    attr_accessor :id
    
    def initialize(attributes)
        super
        @first_name = attributes[:first_name]
        @last_name = attributes[:last_name]
    end

    def invoices
      SalesEngine::Database.instance.invoices.select do |invoice|
        invoice.customer_id == @id
      end
    end

    def self.random
      SalesEngine::Database.instance.customers.sample
    end

    def transactions
      correct_transactions = invoices.collect do |invoice|
        invoice.transactions
      end
      correct_transactions.flatten
    end

  end
end
