module SalesEngine
  class Transaction < Record
    attr_accessor :invoice_id, :credit_card_number, :credit_card_expiration_date, :result

    def initialize(attributes ={})
      super
      self.invoice_id = attributes[:invoice_id]
      self.credit_card_number = attributes[:credit_card_number]
      self.credit_card_expiration_date = attributes[:credit_card_expiration_date]
      self.result = attributes[:result]
    end

    def invoice
      SalesEngine::Database.instance.find_by("invoices", "id", self.invoice_id)
    end

    def self.find_by_invoice_id(id)
      SalesEngine::Database.instance.find_by("transactions", "invoice_id", id)
    end
  end
end
