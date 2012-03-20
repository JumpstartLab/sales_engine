class Item
  attr_accessor :id, :name, :description, :unit_price, :merchant_id, :created_at,
                :updated_at

  def initialize(attributes={})
    self.id = attributes[:id]
    self.name = attributes[:name]
    self.description = attributes[:description]
    self.unit_price = attributes[:unit_price]
    self.merchant_id = attributes[:merchant_id]
    self.created_at = attributes[:created_at]
    self.updated_at = attributes[:updated_at]
  end

  def self.find_by_merchant_id(merchant_id)
  end
end