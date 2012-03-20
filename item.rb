class Item
  attr_accessor :item_id,
                :item_name,
                :description,
                :unit_price,
                :merchant_id,
                :create_date,
                :update_date

  def initialize(items)
    self.item_id = items[:id].to_s
    self.item_name = items[:name].to_s
    self.description = items[:description].to_s
    self.unit_price = items[:unit_price].to_s
    self.merchant_id = items[:merchant_id].to_s
    self.create_date = items[:created_at].to_s
    self.update_date = items[:updated_at].to_s
  end
end