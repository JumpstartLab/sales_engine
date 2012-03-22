module SalesEngine
  class DataStore

    OPTIONS = {:headers => true, :header_converters => :symbol}
    attr_accessor :customers,
                  :invoices,
                  :items,
                  :invoice_items,
                  :transactions,
                  :merchants

    def initialize
     self.customers = load_file("data/customers.csv").collect {|line| SalesEngine::Customer.new(line)}
     self.invoices = load_file("data/invoices.csv").collect {|line| SalesEngine::Invoice.new(line)}
     self.merchants = load_file("data/merchants.csv").collect {|line| SalesEngine::Merchant.new(line)}
     self.items = load_file("data/items.csv").collect {|line| SalesEngine::Item.new(line)}
     self.invoice_items = load_file("data/invoice_items.csv").collect {|line| SalesEngine::InvoiceItem.new(line)}
     self.transactions = load_file("data/transactions.csv").collect {|line| SalesEngine::Transaction.new(line)}
     puts "Data loaded."
   end

   def load_file(filename)
     CSV.open(filename, OPTIONS)
   end
  end
end