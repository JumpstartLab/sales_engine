$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib')).uniq!
require "sales_engine"
require "sales_engine/invoice"

module SalesEngine
  class Merchant
    include SalesEngine
    attr_accessor :id, :name, :created_at, :updated_at

    def initialize(id, name, created_at, updated_at)
      @id = id
      @name = name
      @created_at = created_at
      @updated_at = updated_at
    end

    def invoices
      Database.invoices.select { |invoice| invoice.merchant_id == id }
    end

    def items
      Database.items.select { |item| item.merchant_id == id }
    end

    def self.elements
      Database.merchants
    end  
  end
end