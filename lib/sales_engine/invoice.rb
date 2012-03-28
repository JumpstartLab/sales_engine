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

    def customer
      @customer ||= Customer.find(@customer_id)
    end

    def merchant
      @merchant ||= Merchant.find(@merchant_id)
    end

    def revenue
      InvoiceItem.find_all_by_invoice_id(id).map(&:revenue).inject(:+)
    end
  end
end
