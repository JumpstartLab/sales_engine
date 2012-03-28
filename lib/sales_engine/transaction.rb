module SalesEngine
  class Transaction
    attr_accessor :id, :invoice_id, :credit_card_number,
                  :credit_card_expiration_date, :result, :created_at,
                  :updated_at

    TRANSACTION_ATTS = [
     "id",
     "invoice_id",
     "credit_card_number",
     "credit_card_expiration_date",
     "result"
     ]

    def initialize(attrs)
      self.id = attrs[:id].to_i
      self.invoice_id = attrs[:invoice_id]
      self.credit_card_number = attrs[:credit_card_number]
      self.credit_card_expiration_date = attrs[:credit_card_expiration_date]
      self.result = attrs[:result]
      self.created_at = attrs[:created_at]
      self.updated_at = attrs[:updated_at]
    end

    def self.attributes_for_finders
      TRANSACTION_ATTS
    end

    extend SalesEngine::DynamicFinder

    def self.random 
      transactions = SalesEngine::Database.instance.transaction_list
      random_id = Random.rand(transactions.size)
      self.find_by_id(random_id + 1)
    end

    # def self.find_by_id(id)
    #   SalesEngine::Database.instance.transaction_list.detect do |trans|
    #     trans if trans.id == id
    #   end
    # end

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