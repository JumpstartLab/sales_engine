class Item
  attr_accessor :item_id,
                :item_name,
                :description,
                :unit_price,
                :merchant_id,
                :create_date,
                :update_date

  def initialize(attributes={})
    self.item_id = attributes[:id].to_s
    self.item_name = attributes[:name].to_s
    self.description = attributes[:description].to_s
    self.unit_price = attributes[:unit_price].to_s
    self.merchant_id = attributes[:merchant_id].to_s
    self.create_date = attributes[:created_at].to_s
    self.update_date = attributes[:updated_at].to_s
  end
end