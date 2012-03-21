require "sales_engine"

class Merchant
  include SalesEngine
  attr_accessor :id, :name, :created_at, :updated_at
  
  def initialize(id, name, created_at, updated_at)
  end

  def self.elements
    Database.merchants
  end
end
