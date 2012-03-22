require './lib/sales_engine/model'

module SalesEngine
  class Transaction
    include Model

    attr_reader :invoice, :credit_card_number, :credit_card_expiration, :result

    def initialize(attributes)
      @invoice = attributes[:invoice]
      @credit_card_number = attributes[:credit_card_number]
      @credit_card_expiration = attributes[:credit_card_expiration]
      @result = attributes[:result]

      validate_attributes
    end

    private

    def validate_attributes
      validates_numericality_of :credit_card_number, @credit_card_number
      validates_presence_of :result, @result
    end
  end
end
