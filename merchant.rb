class Merchant
  attr_accessor :id, :name, :created_at, :updated_at

  def initialize(attributes={})
    self.id = attributes[:id]
    self.name = attributes[:name]
    self.created_at = attributes[:created_at]
    self.updated_at = attributes[:updated_at]
  end

  def items(sales_engine)
    # HOW DO I KNOW WHERE THE MASTER LIST OF ITEMS IS
    sales_engine.find_all_items_by_merchant_id(self.id)
  end
end