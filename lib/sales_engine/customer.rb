$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), 'lib')).uniq!
require "sales_engine"
require "sales_engine/database"

module SalesEngine
  class Customer
    include SalesEngine
    attr_accessor :id, :first_name, :last_name, :created_at, :updated_at

    def initialize(id, first_name, last_name, created_at, updated_at) 
      @id = id
      @first_name = first_name
      @last_name = last_name
      @created_at = created_at
      @updated_at = updated_at
    end     

    def self.elements
      Database.transactions
    end

    def invoices
      Database.invoices.select { |invoice| invoice.customer_id == id }  
    end
  end
end