require './data_store'
require './search'

class Merchant
  attr_accessor :id,
                :name,
                :created_at,
                :updated_at

  def initialize(attributes={})
    self.id = attributes[:id]
    self.name = attributes[:name]
    self.created_at = attributes[:created_at]
    self.updated_at = attributes[:updated_at]
  end

  def self.merchants
    merchants = []
    ObjectSpace.each_object(Merchant) {|o| merchants<<o}
    merchants
  end

  def self.random
      self.merchants.sample
      puts self.merchants.sample
  end

  def self.find_by_id(match)
    puts Search.find_all_by("id", match, self.merchants).sample.inspect
  end

  def self.find_all_by_id(match)
    puts Search.find_all_by("id", match, self.merchants).inspect
  end

  def self.find_by_name(match)
    puts Search.find_all_by("name", match, self.merchants).sample.inspect
  end

  def self.find_all_by_name(match)
    puts Search.find_all_by("name", match, self.merchants).inspect
  end

  def self.find_by_updated_at(match)
    puts Search.find_all_by("updated_at", match, self.merchants).sample.inspect
  end

  def self.find_all_by_updated_at(match)
    puts Search.find_all_by("updated_at", match, self.merchants).inspect
  end

  def self.find_by_created_at(match)
    puts Search.find_all_by("created_at", match, self.merchants).sample.inspect
  end

  def self.find_all_by_created_at(match)
    puts Search.find_all_by("created_at", match, self.merchants).inspect
  end
end