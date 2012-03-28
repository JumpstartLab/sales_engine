require 'model'

module SalesEngine
  class Transaction
    include Model

    attr_reader :invoice_id, :credit_card_number, :credit_card_expiration, :result

    def initialize(attributes)
      super(attributes)
      @invoice_id = clean_integer(attributes[:invoice_id])
      @credit_card_number = clean_integer(attributes[:credit_card_number])
      @credit_card_expiration = clean_date(attributes[:credit_card_expiration])
      @result = attributes[:result]

      validate_attributes
    end

    private

    def validate_attributes
      validates_numericality_of :credit_card_number, @credit_card_number
      validates_presence_of :result, @result
      validates_numericality_of :invoice_id, @invoice_id, :integer => true
    end
  end
end
