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
    SalesEngine.instance.find_by("merchants", "id", id)
  end

  def self.find_by_name(name)
    SalesEngine.instance.find_by("merchants", "name", name)
  end

  def self.find_by_created_at(time)
    SalesEngine.instance.find_by("merchants", "created_at", time)
  end

  def self.find_by_updated_at(time)
    SalesEngine.instance.find_by("merchants", "updated_at", time)
  end

  def self.find_all_by_id(id)
    SalesEngine.instance.find_all_by("merchants", "id", id)
  end

  def self.find_all_by_name(name)
    SalesEngine.instance.find_all_by("merchants", "name", name)
  end

  def self.find_all_by_created_at(time)
    SalesEngine.instance.find_all_by("merchants", "created_at", time)
  end

  def self.find_all_by_updated_at(time)
    SalesEngine.instance.find_all_by("merchants", "updated_at", time)
  end
end