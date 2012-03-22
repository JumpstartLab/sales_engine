class SalesEngine
  class Transaction
    
    attr_accessor :invoice_id
    def initialize(attr)
        @id = attr[:id]
        @invoice_id = attr[:invoice_id]
        @credit_card_number = attr[:credit_card_number]
        @credit_card_expiration_date = attr[:credit_card_expiration_date]
        @result = attr[:result]
        @created_at = attr[:created_at]
        @updated_at = attr[:updated_at]
    end
    # def self.random
    # # return a random Merchant
    # end

    # # def self.find_by_X(match)
    # # end

    # # def self.find_all_by_X(match)
    # # end

    def invoice
      temp_invoices = SalesEngine::Database.instance.get_invoices
      correct_invoice = nil
      temp_invoices.each do |the_invoice|
        if the_invoice.id == @invoice_id
          correct_invoice = the_invoice
        end
      end
      correct_invoice
    end
  end
end
