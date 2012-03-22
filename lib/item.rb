require './data_store'
require './search'

class Item
extend Search
  attr_accessor :id,
                :name,
                :description,
                :unit_price,
                :merchant_id,
                :created_at,
                :updated_at

  def initialize(attributes={})
    self.item_id = attributes[:id].to_s
    self.item_name = attributes[:name].to_s
    self.description = attributes[:description].to_s
    self.unit_price = attributes[:unit_price].to_s
    self.merchant_id = attributes[:merchant_id].to_s
    self.created_at = attributes[:created_at].to_s
    self.updated_at = attributes[:updated_at].to_s
  end

  def self.items
    items = []
    ObjectSpace.each_object(Item) {|o| items<<o}
    items
  end

  def self.random
      self.items.sample
      puts self.items.sample
  end

  def self.find_by_id(match)
    puts Search.find_all_by("id", match, self.items).sample.inspect
  end

  def self.find_all_by_id(match)
    puts Search.find_all_by("id", match, self.items).inspect
  end

  def self.find_by_name(match)
    puts Search.find_all_by("name", match, self.items).sample.inspect
  end

  def self.find_all_by_name(match)
    puts Search.find_all_by("name", match, self.items).inspect
  end

  def self.find_by_description(match)
    puts Search.find_all_by("description", match, self.items).sample.inspect
  end

  def self.find_all_by_description(match)
    puts Search.find_all_by("description", match, self.items).inspect
  end

  def self.find_by_unit_price(match)
    puts Search.find_all_by("unit_price", match, self.items).sample.inspect
  end

  def self.find_all_by_unit_price(match)
    puts Search.find_all_by("unit_price", match, self.items).inspect
  end

  def self.find_by_merchant_id(match)
    puts Search.find_all_by("merchant_id", match, self.items).sample.inspect
  end

  def self.find_all_by_merchant_id(match)
    puts Search.find_all_by("merchant_id", match, self.items).inspect
  end

  def self.find_by_updated_at(match)
    puts Search.find_all_by("updated_at", match, self.items).sample.inspect
  end

  def self.find_all_by_updated_at(match)
    puts Search.find_all_by("updated_at", match, self.items).inspect
  end

  def self.find_by_created_at(match)
    puts Search.find_all_by("created_at", match, self.items).sample.inspect
  end

  def self.find_all_by_created_at(match)
    puts Search.find_all_by("created_at", match, self.items).inspect
  end
end