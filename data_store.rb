class DataStore

  OPTIONS = {:headers => true, :header_converters => :symbol}

  attr_accessor :customers,
                :invoices,
                :items,
                :invoice_items,
                :transactions,
                :merchants

  def data_load
    self.customers = DataLoader.load_customers
    self.invoices = DataLoader.load_invoices
    self.merchants = DataLoader.load_merchants
    self.items = DataLoader.load_items
    self.invoice_items = DataLoader.load_invoice_items
    self.transactions = DataLoader.load_transactions
  end

  def load_file(filename)
    CSV.open(filename, OPTIONS)
  end
end