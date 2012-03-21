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

  def self.method_missing(meth, *args, &block)
    if meth.to_s =~ /^find_by_(.+)$/
      SalesEngine::find_by(Database.merchants, $1, args)
    elsif meth.to_s =~ /^find_all_by_(.+)$/
      SalesEngine::find_all_by(Database.merchants, $1, args) 
    else
      super
    end
  end

  def respond_to?(meth)
    if meth.to_s =~ /^find_by_.*$/ || meth.to_s =~ /^find_all_by_.*$/
      true
    else
      super
    end
  end
end

