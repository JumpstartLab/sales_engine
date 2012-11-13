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
    end

    def self.create(attributes)
      attributes[:customer_id] = attributes[:customer].id
      attributes[:merchant_id] = attributes[:merchant].id

      invoice = Invoice.new(attributes)

      attributes[:items].each do |item|
        InvoiceItem.new(
          :unit_price => item.unit_price,
          :invoice_id => invoice.id,
          :item_id => item.id,
          :quantity => 1
        )
      end

      invoice
    end

    def customer
      @customer ||= Customer.find(@customer_id)
    end

    def merchant
      @merchant ||= Merchant.find(@merchant_id)
    end

    def revenue
      if transaction_successful?
        InvoiceItem.find_all_by_invoice_id(id).map(&:revenue).map { |rev| BigDecimal.new(rev.to_s) }.inject(:+)
      else
        BigDecimal.new('0')
      end
    end

    def transactions
      Transaction.find_all_by_invoice_id(id)
    end

    def transaction_successful?
      transactions && transactions.any? { |t| t.successful? }
    end

    def invoice_item_count
      InvoiceItem.find_all_by_invoice_id(id).map { |invoice_item| transaction_successful? ? invoice_item.quantity : 0 }.inject(:+)
    end

    def items
      InvoiceItem.find_all_by_invoice_id(id)
    end

    def invoice_items
      items
    end
  end
end
