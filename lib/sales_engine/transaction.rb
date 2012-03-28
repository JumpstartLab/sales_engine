require 'sales_engine/model'

class SalesEngine
  class Transaction
    ATTRIBUTES = ["id", "created_at", "updated_at", "invoice_id",
                  "credit_card_number", "credit_card_expiration_date", "result"]

    attr_accessor :invoice_id, :credit_card_number, :credit_card_expiration_date

    def initialize(attr)
      super(attr)
      @invoice_id = attr[:invoice_id]
      @credit_card_number = attr[:credit_card_number]
      @credit_card_expiration_date = attr[:credit_card_expiration_date]
      @result = attr[:result]
    end

    def self.finder_attributes
      ATTRIBUTES
    end

    include Model

    def invoice
      SalesEngine::Database.instance.invoices.find do |invoice|
        invoice.id == @invoice_id
      end
    end

    def self.all
      SalesEngine::Database.instance.transactions
    end

  end
end
