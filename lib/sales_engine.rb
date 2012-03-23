require 'bigdecimal'
require 'date'
require 'sales_engine/csv_loader'

module SalesEngine
  def self.startup
    SalesEngine::CsvLoader.new
  end
end

# SE.load_invoices
# puts SE.invoices