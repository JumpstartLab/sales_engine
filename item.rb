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

  def self.find_by_merchant_id(merchant_id)
  end
end