require 'csv'
require './Customer'
require './Invoice'
require './InvoiceItem'
require './Transaction'
require './Item'
require './Merchant'

class SalesEngine
  CSV_OPTIONS = {:headers => true, :header_converters => :symbol}  

  attr_accessor :invoices, :invoiceitems, :items, :transactions, :merchants, :customers

  def initialize
    load_customers
    load_invoices
    load_invoiceitems
    load_items
    load_transactions
    load_merchants
  end

  def load_customers(options=CSV_OPTIONS)
    customers = CSV.open("csv_data/customers.csv", options)
    self.customers = customers.collect {|line| Customer.new(line)}
  end

  def load_invoices(options=CSV_OPTIONS)
    invoices = CSV.open("csv_data/items.csv", options)
    self.invoices = invoices.collect {|line| Invoice.new(line)}
  end

  def load_invoiceitems(options=CSV_OPTIONS)
    invoiceitems = CSV.open("csv_data/invoice_items.csv", options)
    self.invoiceitems = invoiceitems.collect {|line| InvoiceItem.new(line)}
  end

  def load_items(options=CSV_OPTIONS)
    items = CSV.open("csv_data/items.csv", options)
    self.items = items.collect {|line| Item.new(line)}
  end

  def load_transactions(options=CSV_OPTIONS)
    transactions = CSV.open("csv_data/transactions.csv", options)
    self.transactions = transactions.collect {|line| Transaction.new(line)}
  end

  def load_merchants(options=CSV_OPTIONS)
    merchants = CSV.open("csv_data/merchants.csv", options)
    self.merchants = merchants.collect {|line| Merchant.new(line)}
  end
end

test = SalesEngine.new
puts test.customers.collect { |customer| customer.first_name }