class SalesEngine
  class Customer
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

    # def invoices
    # end
  end
end
