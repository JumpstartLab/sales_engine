class Merchant
  attr_accessor :merchant_id,
                :merchant_name,
                :create_date,
                :update_date

  def initialize(attributes={})
    self.merchant_id = attributes[:id]
    self.merchant_name = attributes[:name]
    self.create_date = attributes[:created_at]
    self.update_date = attributes[:updated_at]
  end
end