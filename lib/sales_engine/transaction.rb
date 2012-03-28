$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib')).uniq!
require "sales_engine"
require "sales_engine/database"

module SalesEngine
  class Transaction
    include SalesEngine
    attr_accessor :id, :invoice_id, :credit_card_number,
    :credit_card_expiration_date, :result, :created_at, :updated_at

    def initialize(id, invoice_id, credit_card_number, 
                   credit_card_expiration_date, result, 
                   created_at, updated_at) 
      @id = id
      @invoice_id = invoice_id
      @credit_card_number = credit_card_number
      @credit_card_expiration_date = credit_card_expiration_date
      @result = result
      @created_at = created_at
      @updated_at = updated_at
    end     

    def self.elements
      transactions
    end

    def invoice
      Invoice.invoices.find { |invoice| invoice.id == invoice_id }  
    end
  end
end
