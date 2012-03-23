module SalesEngine
  class SalesEngine::Invoice
    attr_accessor :id, :customer_id, :merchant_id, :status, :created_at, :updated_at

    # def initialize
    # end

    # def load

    # end

    # def transactions
    #   # transactions returns a collection of associated Transaction instances
    # end

    # def invoice_items
    #   # invoice_items returns a collection of associated InvoiceItem instances    
    # end

    # def items
    #   # items returns a collection of associated Items by way of InvoiceItem objects    
    # end

    def customer
      # customer returns an instance of Customer associated with this object
    end


  end
end