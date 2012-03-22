module SalesEngine
  class Database
    class << self
      attr_accessor :merchants, :invoices, :items, :invoice_items
    end
  end
end 