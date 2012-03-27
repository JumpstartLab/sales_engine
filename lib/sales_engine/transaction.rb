require 'sales_engine/model'

class SalesEngine
  class Transaction
    include Model

    attr_accessor :invoice_id

    def initialize(attr)
      super(attr)
      @invoice_id = attr[:invoice_id]
      @credit_card_number = attr[:credit_card_number]
      @credit_card_expiration_date = attr[:credit_card_expiration_date]
      @result = attr[:result]
    end
    # # def self.find_by_X(match)
    # # end

    # # def self.find_all_by_X(match)
    # # end

    def invoice
      SalesEngine::Database.instance.invoices.find do |invoice|
        invoice.id == @invoice_id
      end
    end

    def self.random
      SalesEngine::Database.instance.transactions.sample
    end

    def self.all
      SalesEngine::Database.instance.transactions
    end

    def self.find_by_invoice_id(param)
      self.all.find do |transaction|
        transaction.invoice_id == param
      end
    end
  end
end
