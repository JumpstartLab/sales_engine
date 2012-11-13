require 'singleton'
require 'csv'
require 'sales_engine/customer'
require 'sales_engine/invoice'
require 'sales_engine/invoice_item'
require 'sales_engine/transaction'
require 'sales_engine/item'
require 'sales_engine/merchant'

module SalesEngine
  class Database
    include Singleton
    CSV_OPTIONS = {:headers => true, :header_converters => :symbol}
    attr_accessor :invoices, :invoiceitems,
                  :items, :transactions, :merchants, :customers

    def initialize
      load_customers
      load_invoices
      load_more_reek
    end

    def load_more_reek
      load_invoiceitems
      load_items
      load_transactions
      load_merchants
    end

    private

    def load_data(file, klass, options)
      rows = CSV.open("data/#{file}", options)
      rows.collect {|line| klass.new(line)}
    end

    def load_invoices(options=CSV_OPTIONS)
      self.invoices = load_data("invoices.csv", Invoice, options)
      successful_load("invoices")
    end

    def load_customers(options=CSV_OPTIONS)
      self.customers = load_data("customers.csv", Customer, options)
      successful_load("customers")
    end

    def load_invoiceitems(options=CSV_OPTIONS)
      self.invoiceitems = load_data("invoices.csv", Invoiceitem, options)
      successful_load("invoice items")
    end

    def load_items(options=CSV_OPTIONS)
      self.items = load_data("items.csv", Item, options)
      successful_load("items")
    end

    def load_transactions(options=CSV_OPTIONS)
      self.transactions = load_data("transactions.csv", Transaction, options)
      successful_load("transactions")
    end

    def load_merchants(options=CSV_OPTIONS)
      self.merchants = load_data("merchants.csv", Merchant, options)
      successful_load("merchants")
    end

    def successful_load(param)
      puts "Successfully loaded #{param}"
    end
  end
end



