require 'singleton'

module SalesEngine
  class DataStore
    include Singleton

    OPTIONS = {:headers => true, :header_converters => :symbol}
    attr_accessor :customers,
                  :invoices,
                  :items,
                  :invoice_items,
                  :transactions,
                  :merchants

    def initialize
      load_customers
      load_invoices
      load_merchants
      load_items
      load_invoice_items
      load_transactions
    end

    def load_file(filename)
       CSV.open(filename, OPTIONS)
    end

    def load_customers
      cust           = load_file("data/customers.csv")
      self.customers = cust.collect {|line| SalesEngine::Customer.new(line)}
    end

    def load_invoices
      invoices      = load_file("data/invoices.csv")
      self.invoices = invoices.collect {|line| SalesEngine::Invoice.new(line)}
    end

    def load_merchants
      merch          = load_file("data/merchants.csv")
      self.merchants = merch.collect {|line| SalesEngine::Merchant.new(line)}
    end

    def load_items
      items      = load_file("data/items.csv")
      self.items = items.collect {|line| SalesEngine::Item.new(line)}
    end

    def load_invoice_items
      i                  = load_file("data/invoice_items.csv")
      self.invoice_items = i.collect {|line| SalesEngine::InvoiceItem.new(line)}
    end

    def load_transactions
      t                 = load_file("data/transactions.csv")
      self.transactions = t.collect {|line| SalesEngine::Transaction.new(line)}
    end
  end
end