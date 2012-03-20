class Merchant
  attr_accessor :merchant_id,
                :merchant_name,
                :create_date,
                :update_date

  def initialize(merchant)
    self.merchant_id = merchant[:id].to_s
    self.merchant_name = merchant[:name].to_s
    self.create_date = merchant[:created_at].to_s
    self.update_date = merchant[:updated_at].to_s
  end
end