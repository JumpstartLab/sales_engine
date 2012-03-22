require './lib/sales_engine/model'

module SalesEngine
  class Invoice
    include Model

    attr_reader :customer, :merchant, :status

    def initialize(attributes)
      @customer = attributes[:customer]
      @merchant = attributes[:merchant]
      @status = attributes[:status]
    end
  end
end
