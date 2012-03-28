require 'model'

module SalesEngine
  class Invoice
    include Model

    attr_reader :customer_id, :merchant_id, :status

    def initialize(attributes)
      super(attributes)

      @customer_id = clean_integer(attributes[:customer_id])
      @merchant_id = clean_integer(attributes[:merchant_id])
      @status = attributes[:status]

      validates_numericality_of :customer_id, @customer_id, :integer => true
      validates_numericality_of :merchant_id, @merchant_id, :integer => true
      validates_presence_of :status, @status
    end
  end
end
