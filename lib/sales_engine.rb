require 'bigdecimal'
require 'date'
require 'sales_engine/csv_loader'

module SalesEngine
  def self.startup
    SalesEngine::CsvLoader.load_transactions
    SalesEngine::CsvLoader.load_customers
    SalesEngine::CsvLoader.load_items
    SalesEngine::CsvLoader.load_merchants
    SalesEngine::CsvLoader.load_invoices_items
    SalesEngine::CsvLoader.load_invoices
  end
end

# SE.load_invoices
# puts SE.invoices