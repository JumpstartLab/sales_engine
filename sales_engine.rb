require 'csv'
require './customer'
require './invoice'
require './merchant'
require './invoice_item'
require './item'
require './transaction'

class SalesEngine

  attr_accessor :customers,
                :invoices,
                :items,
                :invoice_items,
                :transactions,
                :merchants
                
  def initialize
    import_invoices
    import_merchants
    import_transactions
    import_customers
    import_items
    import_invoice_items
  end

  def import_customers
    options = {:headers => true, :header_converters => :symbol}
    file = CSV.open("customers.csv", options)
    self.customers = file.collect {|line| Customer.new(line)}
  end

  def import_invoices
    options = {:headers => true, :header_converters => :symbol}
    file = CSV.open("invoices.csv", options)
    self.invoices = file.collect {|line| Invoice.new(line)}
  end

  def import_merchants
    options = {:headers => true, :header_converters => :symbol}
    file = CSV.open("merchants.csv", options)
    self.merchants = file.collect {|line| Merchant.new(line)}
  end

  def import_transactions
    options = {:headers => true, :header_converters => :symbol}
    file = CSV.open("transactions.csv", options)
    self.transactions = file.collect {|line| Transaction.new(line)}
  end

  def import_items
    options = {:headers => true, :header_converters => :symbol}
    file = CSV.open("items.csv", options)
    self.items = file.collect {|line| Item.new(line)}
  end
  def import_invoice_items
    options = {:headers => true, :header_converters => :symbol}
    file = CSV.open("invoice_items.csv", options)
    self.invoice_items = file.collect {|line| InvoiceItem.new(line)}
  end

end

se = SalesEngine.new