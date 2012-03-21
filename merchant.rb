require './record'

class Merchant < Record
  attr_accessor :name

  def initialize(attributes={})
    super
    self.name = attributes[:name]
  end

  def items
    SalesEngine.instance.find_all_items_by_merchant_id(self.id)
  end

  def invoices
    SalesEngine.instance.find_all_invoices_by_merchant_id(self.id)
  end

  def self.random
    SalesEngine.instance.get_random_record("merchant")
  end

  def self.find_by_id(id)
    SalesEngine.instance.find_merchant_by_id(id)
  end

  def self.find_by_name(name)
    SalesEngine.instance.find_merchant_by_name(name)
  end
end