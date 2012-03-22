require './record'

class Item < Record
  attr_accessor :name, :description, :unit_price, :merchant_id

  def initialize(attributes={})
    super
    self.name = attributes[:name]
    self.description = attributes[:description]
    self.unit_price = attributes[:unit_price]
    self.merchant_id = attributes[:merchant_id]
  end

 def self.random
    SalesEngine.instance.get_random_record("items")
  end

  def self.find_by_id(id)
    SalesEngine.instance.find_by("items", "id", id)
  end

  def self.find_by_name(name)
    SalesEngine.instance.find_by("items", "name", name)
  end

  def self.find_by_description(description)
    SalesEngine.instance.find_by("items", "description", description)
  end
  
  def self.find_by_unit_price(unit_price)
    SalesEngine.instance.find_by("items", "unit_price", unit_price)
  end

  def self.find_by_merchant_id(merchant_id)
    SalesEngine.instance.find_by("items", "merchant_id", merchant_id)
  end

  def self.find_by_created_at(time)
    SalesEngine.instance.find_by("items", "created_at", time)
  end

  def self.find_by_updated_at(time)
    SalesEngine.instance.find_by("items", "updated_at", time)
  end

  def self.find_all_by_id(id)
    SalesEngine.instance.find_all_by("items", "id", id)
  end

  def self.find_all_by_name(name)
    SalesEngine.instance.find_all_by("items", "name", name)
  end

  def self.find_all_by_description(description)
    SalesEngine.instance.find_all_by("items", "description", description)
  end

  def self.find_all_by_unit_price(unit_price)
    SalesEngine.instance.find_all_by("items", "unit_price", unit_price)
  end

  def self.find_all_by_merchant_id(merchant_id)
    SalesEngine.instance.find_all_by("items", "merchant_id", merchant_id)
  end

  def self.find_all_by_created_at(time)
    SalesEngine.instance.find_all_by("items", "created_at", time)
  end

  def self.find_all_by_updated_at(time)
    SalesEngine.instance.find_all_by("items", "updated_at", time)
  end
end