#require './transaction'
#require './customer'
#require './invoice_item'
#require './item'
require './lib/sales_engine'

module SalesEngine
  class Invoice
    extend Find

    # id,customer_id,merchant_id,status,created_at,updated_at
    # invoice = Invoice.new(:customer_id => customer, :merchant_id => merchant, :status => "shipped", :items => [item1, item2, item3], :transaction => transaction)

    attr_accessor :id, :customer_id, :merchant_id, :status, 
                  :created_at, :updated_at, :revenue, :success 

    def initialize(attributes={})
      self.id           = attributes[:id].to_i
      self.customer_id  = attributes[:customer_id].to_i
      self.merchant_id  = attributes[:merchant_id].to_i
      self.status       = attributes[:status]
      self.created_at   = Date.parse(attributes[:created_at])
      self.updated_at   = Date.parse(attributes[:updated_at])
    end

    def self.create(attributes={})
      inv = self.new({:id           => Database.instance.invoices.count + 1,
                      :customer_id  => attributes[:customer].id, 
                      :merchant_id  => attributes[:merchant].id,
                      :status       => attributes[:status],
                      :created_at   => DateTime.now.to_s,
                      :updated_at   => DateTime.now.to_s})

      SalesEngine::Database.instance.invoices << inv

      SalesEngine::InvoiceItem.create(inv.id, attributes[:items])

      inv
    end

    def charge(attributes)
     t = SalesEngine::Transaction.new({
              :id => Database.instance.transactions.count + 1,
              :invoice_id => self.id,
              :credit_card_number => attributes[:credit_card_number],
              :credit_card_expiration_date => attributes[:credit_card_expiration_date],
              :result => attributes[:result]})
     SalesEngine::Database.instance.transactions << t

     t
    end

    class << self
      attributes = [:id, :customer_id, :merchant_id, :status, 
                    :created_at, :updated_at, :date]
      attributes.each do |attribute|
        define_method "find_by_#{attribute}" do |input|
          find_invoices(attribute, input)
        end
        define_method "find_all_by_#{attribute}" do |input|
          find_all_invoices(attribute, input)
        end
      end
    end

    def revenue
      @revenue ||= invoice_items.map { |inv_item| inv_item.total }.inject(:+)
    end

    def date
      #self.created_at.split[0]
      self.created_at
    end

    def self.random
      Database.instance.invoices.sample
    end

    def success
      @success ||= begin
        self.transactions.each do |t|
          if t.successful?
            @success = true
          end
        end
        @success
      end
    end

    def transactions
      SalesEngine::Transaction.find_all_by_invoice_id(self.id)
    end

    def invoice_items
      SalesEngine::InvoiceItem.find_all_by_invoice_id(self.id)
    end

    def items
      #items returns a collection of associated Items by way of InvoiceItem objects
      self.invoice_items.collect do |inv_item|
        inv_item.item
      end
    end

    def customer
      SalesEngine::Customer.find_by_id(self.customer_id)
    end



  end
end