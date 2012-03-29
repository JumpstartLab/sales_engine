require 'sales_engine/model'

class SalesEngine
  class Transaction
    ATTRIBUTES = ["id", "created_at", "updated_at", "invoice_id",
                  "credit_card_number", "credit_card_expiration_date", "result"]
    def self.finder_attributes
      ATTRIBUTES
    end

    include Model

    attr_accessor :id, :invoice_id, :credit_card_number, :credit_card_expiration_date,
      :created_at, :updated_at, :result

    def initialize(attr)
      super(attr)
      @id = attr[:id]
      @invoice_id = attr[:invoice_id].to_i
      @credit_card_number = attr[:credit_card_number]
      @credit_card_expiration_date = attr[:credit_card_expiration_date]
      @result = attr[:result]
    end

    def invoice
      puts "TODO in #{self.class}"
      SalesEngine::Invoice.find_by_id(@invoice_id)

      # SalesEngine::Database.instance.invoices.find do |invoice|
      #   invoice.id == @invoice_id
      # end
    end
  end
end
