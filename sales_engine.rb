$LOAD_PATH.unshift('./')
$LOAD_PATH.unshift('./lib/sales_engine')

require 'csv_loader'
require 'bigdecimal'

def startup
  SalesEngine::CSVLoader.new
end

startup

# SE.load_invoices
# puts SE.invoices