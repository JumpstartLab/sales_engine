module SalesEngine
  class Transaction
    attr_accessor :id, :invoice_id, :credit_card_number, :credit_card_expiration_date, :result, :created_at, :updated_at
    # Overachievers:
    # TRANSACTION_ATTS = [ "id", "invoice_id", "credit_card_number", "credit_card_expiration_date",
    #   "result", "created_at", "updated_at" ]

    def initialize(attributes)
      self.id = attributes[:id]
      self.invoice_id = attributes[:invoice_id]
      self.credit_card_number = attributes[:credit_card_number]
      self.credit_card_expiration_date = attributes[:credit_card_expiration_date]
      self.result = attributes[:result]
      self.created_at = attributes[:created_at]
      self.updated_at = attributes[:updated_at]
    end

    def invoice
      SalesEngine::Invoice.find_by_id(self.invoice_id)
    end

    def is_successful?
      self.result == "success"
    end

    def self.find_all_by_invoice_id(invoice_id)
      SalesEngine::Database.instance.transaction_list.select do |trans| 
        trans if trans.invoice_id == invoice_id
      end
    end

    def self.find_all_by_result(result)
      SalesEngine::Database.instance.transaction_list.select do |trans|
        trans if trans.result == result
      end
    end
  end
end