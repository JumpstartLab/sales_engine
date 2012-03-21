class Item
  attr_accessor :id, :name, :description, :unit_price, :merchant_id, :created_at, :updated_at

  ITEM_ATTS = [
    "id",
    "name",
    "description",
    "unit_price",
    "merchant_id",
    "created_at",
    "updated_at"
    ]
    
  def initialize(attributes)
    self.id = attributes[:id]
    self.name = attributes[:name]
    self.description = attributes[:description]
    self.unit_price = attributes[:unit_price]
    self.merchant_id = attributes[:marchant_id]
    self.created_at = attributes[:created_at]
    self.updated_at = attributes[:updated_at]
  end

  ITEM_ATTS.each do |att|
    define_singleton_method ("find_by_" + att).to_sym do |param|
      Database.instance.item_list.detect{ |item| item.send(att.to_sym) == param }
    end
  end
end