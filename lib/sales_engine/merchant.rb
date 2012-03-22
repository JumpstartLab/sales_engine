require './lib/sales_engine/record'

class Merchant < Record
  attr_accessor :name

  def initialize(attributes={})
    super
    self.name = attributes[:name]
  end

  def items
    Database.instance.find_all_items_by_merchant_id(self.id)
  end

  def invoices
    Database.instance.find_all_invoices_by_merchant_id(self.id)
  end

  def self.random
    Database.instance.get_random_record("merchants")
  end

  def self.find_by_id(id)
    Database.instance.find_by("merchants", "id", id)
  end

  def self.find_by_name(name)
    Database.instance.find_by("merchants", "name", name)
  end

  def self.find_by_created_at(time)
    Database.instance.find_by("merchants", "created_at", time)
  end

  def self.find_by_updated_at(time)
    Database.instance.find_by("merchants", "updated_at", time)
  end

  def self.find_all_by_id(id)
    Database.instance.find_all_by("merchants", "id", id)
  end

  def self.find_all_by_name(name)
    Database.instance.find_all_by("merchants", "name", name)
  end

  def self.find_all_by_created_at(time)
    Database.instance.find_all_by("merchants", "created_at", time)
  end

  def self.find_all_by_updated_at(time)
    Database.instance.find_all_by("merchants", "updated_at", time)
  end
end