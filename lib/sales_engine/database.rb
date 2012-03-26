module SalesEngine
  class Database
    class << self
      attr_accessor :merchants, :invoices, :items,
                    :invoice_items, :transactions, :customers                    
    end
  end
end 
