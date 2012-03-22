#require './transaction'
#require './customer'
#require './invoice_item'
#require './item'

module SalesEngine
  class Invoice
    extend Find

    # id,customer_id,merchant_id,status,created_at,updated_at
    # invoice = Invoice.new(:customer_id => customer, :merchant_id => merchant, :status => "shipped", :items => [item1, item2, item3], :transaction => transaction)

    attr_accessor :id, :customer_id, :merchant_id, :status, :created_at, :updated_at

    def initialize(attributes={})
      self.id           = attributes[:id]
      self.customer_id  = attributes[:customer_id]
      self.merchant_id  = attributes[:merchant_id]
      self.status       = attributes[:status]
      self.created_at   = attributes[:created_at]
      self.updated_at   = attributes[:updated_at]
    end

    class << self
      attributes = [:id, :customer_id, :merchant_id, :status, 
                    :created_at, :updated_at]
      attributes.each do |attribute|
        define_method "find_by_#{attribute}" do |input|
          find_invoices(attribute, input.to_s)
        end
        define_method "find_all_by_#{attribute}" do |input|
          find_all_invoices(attribute, input.to_s)
        end
      end
    end

    def self.random
      puts "#{Database.instance.invoices.sample.inspect}"
      Database.instance.invoices.sample
    end

    def transactions
      # returns a collection of associated Transaction instances
      "You called the transactions method."
      #result = []
      Database.instance.transactions.select do |t|
        t.send(:invoice_id) == self.id
      end
    end

    def invoice_items
      #invoice_items returns a collection of associated InvoiceItem instances
      "You called the invoice items"
      Database.instance.invoice_items.select do |ii|
        ii.send(:invoice_id) == self.id
      end
    end

    def items
      #items returns a collection of associated Items by way of InvoiceItem objects
    end

    def customer
      #customer returns an instance of Customer associated with this object
    end

    def charge 
      # invoice.charge(:credit_card_number => "4444333322221111", :credit_card_expiration => "10/13", :result => "success")
      # will call new instance of Transaction
    end

  end
end