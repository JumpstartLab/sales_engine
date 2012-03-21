require "sales_engine"

class Merchant
  include SalesEngine
  attr_accessor :id, :name, :created_at, :updated_at
  
  def initialize(id, name, created_at, updated_at)

  end

  def self.random
    merchants = Database.merchants
    if merchants && merchants.length > 0
      merchants[Random.rand(Database.merchants.length - 1)]
    else
      nil
    end
  end
end

