class DataLoader
  def self.load_customers
    load_file("customers.csv").collect {|line| Customer.new(line)}
  end

  def self.load_invoices
    load_file("invoices.csv").collect {|line| Invoice.new(line)}   
  end

  def self.load_merchants
    load_file("merchants.csv").collect {|line| Merchant.new(line)}
  end

  def self.load_items
    load_file("items.csv").collect {|line| Item.new(line)}
  end

  def self.load_invoice_items
    load_file("invoice_items.csv").collect {|line| InvoiceItem.new(line)}
  end

  def self.load_transactions
    load_file("transactions.csv").collect {|line| Transaction.new(line)}
  end
end