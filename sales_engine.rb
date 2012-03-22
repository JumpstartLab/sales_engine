$LOAD_PATH.unshift('./')
require 'csv_loader'

class SalesEngine
  def initialize
    CSVLoader.new
  end

end

SE = SalesEngine.new

# SE.load_invoices
# puts SE.invoices