module SalesEngine
  class Transaction
    attr_accessor :id, :invoice_id, :credit_card_number, :credit_card_expiration_date, :result, :created_at, :updated_at

    def initialize(attributes)
      self.id         = attributes[:id]
      self.invoice_id = attributes[:invoice_id]
      self.credit_card_number = attributes[:credit_card_number]
      self.credit_card_expiration_date = attributes[:credit_card_expiration_date]
      self.result     = attributes[:result]
      self.created_at = attributes[:created_at]
      self.updated_at = attributes[:updated_at]
    end

    def self.collection
      database.transactions
    end

    def self.database
      SalesEngine::Database.instance
    end

    def database
      @database ||= SalesEngine::Database.instance
    end

    def database=(input)
      @database = input
    end

    def invoice
      matched_invoices = SalesEngine::Invoice.find_all_by_id(self.invoice_id)
      matched_invoices[0]
    end

    def successful?
      result == "success"
    end

    def self.find_all_by_date(date)
      successful_transactions.select{ |transaction| transaction.created_at == date  }
    end

    def self.successful_transactions
      collection.select{ |t| t.result == "success" }
    end

    def find_by_date(date)
      collection.select{ |transaction| transaction.successful?.created_at == date  }
    end

  end
end