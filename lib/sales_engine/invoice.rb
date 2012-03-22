$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib')).uniq!
require "sales_engine"
require "sales_engine/database"

module SalesEngine
  class Invoice
    include SalesEngine
    attr_accessor :id, :customer_id, :merchant_id,
    :status, :created_at, :updated_at
    def self.elements
      Database.invoices
    end
  end
end