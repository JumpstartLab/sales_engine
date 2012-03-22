require './lib/sales_engine/model'

module SalesEngine
  class Invoice
    include Model

    attr_reader :customer, :merchant, :status

    def initialize(attributes)
      @customer = attributes[:customer]
      @merchant = attributes[:merchant]
      @status = attributes[:status]

      validates_presence_of :customer, @customer
      validates_presence_of :merchant, @merchant
      validates_presence_of :status, @status
    end
  end
end
