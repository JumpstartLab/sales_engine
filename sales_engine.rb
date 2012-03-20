require 'csv'
require './merchant'

class SalesEngine

  CSV_OPTIONS         = {:headers => true, :header_converters => :symbol}
  MERCHANT_DATA       = "merchants.csv"
  CUSTOMER_DATA       = "customers.csv"
  ITEM_DATA           = "items.csv"
  INVOICE_DATA        = "invoices.csv"
  INVOICE_ITEMS_DATA  = "invoice_items.csv"
  TRANSACTION_DATA    = "transactions.csv"

  attr_accessor :merchants, :customers, :items, :invoices, 
                :invoice_items, :transactions

  def initialize
    load_merchants 
    load_customers
    load_items
    load_invoices 
    load_invoice_items
    load_transactions
  end

  def load_merchants
    merch_file = CSV.open(MERCHANT_DATA, CSV_OPTIONS)
    merchants = merch_file.collect { |m| Merchant.new(m) }
  end

  def load_customers 
    cust_file = CSV.open(CUSTOMER_DATA, CSV_OPTIONS)
    customers = cust_file.collect { |c| Customer.new(c) }
  end 

  def load_items
    items_file = CSV.open(ITEM_DATA, CSV_OPTIONS)
    items = items_file.collect { |i| Item.new(i) }
  end

  def load_invoices
    inv_file = CSV.open(INVOICE_DATA, CSV_OPTIONS)
    invoices = inv_file.collect { |i| Invoice.new(i) }
  end

  def load_invoice_items
    inv_item_file = CSV.open(INVOICE_ITEMS_DATA, CSV_OPTIONS)
    invoice_items = inv_item_file.collect { |i| InvoiceItem.new(i) }
  end   

  def load_transactions
    trans_file = CSV.open(TRANSACTION_DATA, CSV_OPTIONS)
    transactions = trans_file.collect { |t| Transaction.new(t) }
  end
end