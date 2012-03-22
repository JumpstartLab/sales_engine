class SalesEngine
  class Customer
    attr_accessor :id
    
    def initialize(attributes)
        @id = attributes[:id]
        @first_name = attributes[:first_name]
        @last_name = attributes[:last_name]
        @created_at = attributes[:created_at]
        @updated_at = attributes[:updated_at]
    end
    # def self.random
    # # return a random Merchant
    # end

    # # def self.find_by_X(match)
    # # end

    # # def self.find_all_by_X(match)
    # # end

    def invoices
        temp_invoices = SalesEngine::Database.instance.get_invoices
        correct_invoices = []
        temp_invoices.each do |invoice|
            if invoice.customer_id == @id
                correct_invoices << invoice
            end
        end
        return correct_invoices
    end
  end
end
