require 'csv'
require './database'
require './merchant'
require './customer'
require './item'
require './invoice'
require './invoice_item'
require './transaction'

class SalesEngine

  CSV_OPTIONS         = {:headers => true, :header_converters => :symbol}
  MERCHANT_DATA       = "merchants.csv"
  CUSTOMER_DATA       = "customers.csv"
  ITEM_DATA           = "items.csv"
  INVOICE_DATA        = "invoices.csv"
  INVOICE_ITEMS_DATA  = "invoice_items.csv"
  TRANSACTION_DATA    = "transactions.csv"

  def initialize
    load_merchants
    load_customers
    load_items
    load_invoices 
    load_transactions
    load_invoice_items
  end

  def load_merchants
    merch_file = CSV.open(MERCHANT_DATA, CSV_OPTIONS)
    Database.instance.merchants = merch_file.collect { |m| Merchant.new(m) }
    puts "Merchants loaded."
  end

  def load_customers 
    cust_file = CSV.open(CUSTOMER_DATA, CSV_OPTIONS)
    Database.instance.customers = cust_file.collect { |c| Customer.new(c) }
    puts "Customers loaded."
  end 

  def load_items
    items_file = CSV.open(ITEM_DATA, CSV_OPTIONS)
    Database.instance.items = items_file.collect { |i| Item.new(i) }
    puts "Items loaded."
  end

  def load_invoices
    inv_file = CSV.open(INVOICE_DATA, CSV_OPTIONS)
    Database.instance.invoices = inv_file.collect { |i| Invoice.new(i) }
    puts "Invoices loaded."
  end

  def load_invoice_items
    ii_file = CSV.open(INVOICE_ITEMS_DATA, CSV_OPTIONS)
    Database.instance.invoice_items = ii_file.collect { |i| InvoiceItem.new(i).inspect }
    puts "Invoice items loaded."
  end 

  def load_transactions
    t_file = CSV.open(TRANSACTION_DATA, CSV_OPTIONS)
    Database.instance.transactions = t_file.collect { |t| Transaction.new(t) }
    puts "Transactions loaded."
  end
end