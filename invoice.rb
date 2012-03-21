require './transaction'
require './customer'
require './invoice_item'
require './item'

class Invoice

  # id,customer_id,merchant_id,status,created_at,updated_at
  # invoice = Invoice.new(:customer_id => customer, :merchant_id => merchant, :status => "shipped", :items => [item1, item2, item3], :transaction => transaction)

  INVOICES            = []
  CSV_OPTIONS         = {:headers => true, :header_converters => :symbol}
  INVOICE_DATA        = "invoices.csv"

  attr_accessor :id, :customer_id, :merchant_id, :status, :created_at, :updated_at

  def initialize(attributes={})
    self.id           = attributes[:id]
    self.customer_id  = attributes[:customer_id]
    self.merchant_id  = attributes[:merchant_id]
    self.status       = attributes[:status]
    self.created_at   = attributes[:created_at]
    self.updated_at   = attributes[:updated_at]
  end

  def self.load_data
    inv_file = CSV.open(INVOICE_DATA, CSV_OPTIONS)
    inv_file.collect do |i| 
      INVOICES << Invoice.new(i)
    end
    puts "Loaded Invoice data."
  end

  def transactions
    # returns a collection of associated Transaction instances
  end

  def invoice_items
    #invoice_items returns a collection of associated InvoiceItem instances
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