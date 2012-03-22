require './record'

class Customer < Record
  attr_accessor :first_name, :last_name

  def initialize(attributes={})
    super
    self.first_name = attributes[:first_name]
    self.first_name = attributes[:last_name]
  end

  def self.random
    SalesEngine.instance.get_random_record("customers")
  end

  def self.find_by_id(id)
    SalesEngine.instance.find_by("customers", "id", id)
  end

  def self.find_by_first_name(first_name)
    SalesEngine.instance.find_by("customers", "first_name", first_name)
  end

  def self.find_by_last_name(last_name)
    SalesEngine.instance.find_by("customers", "last_name", last_name)
  end

  def self.find_by_created_at(time)
    SalesEngine.instance.find_by("customers", "created_at", time)
  end

  def self.find_by_updated_at(time)
    SalesEngine.instance.find_by("customers", "updated_at", time)
  end

  def self.find_all_by_id(id)
    SalesEngine.instance.find_all_by("customers", "id", id)
  end

  def self.find_all_by_first_name(first_name)
    SalesEngine.instance.find_all_by("customers", "first_name", first_name)
  end

  def self.find_all_by_last_name(last_name)
    SalesEngine.instance.find_all_by("customers", "last_name", last_name)
  end

  def self.find_all_by_created_at(time)
    SalesEngine.instance.find_all_by("customers", "created_at", time)
  end

  def self.find_all_by_updated_at(time)
    SalesEngine.instance.find_all_by("customers", "updated_at", time)
  end
end