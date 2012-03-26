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
      SalesEngine::Database.instance.transactions
    end

    def invoice
      transactions = SalesEngine::Database.instance.transactions
      matched_transactions = transactions.select { |transaction| transaction.id == self.id }
      transaction_ids = matched_transactions.map { |transaction| transaction.invoice_id }
      transaction_ids.map { |transaction_id| SalesEngine::Invoice.find_by_id(transaction_id) }
    end

  end
end