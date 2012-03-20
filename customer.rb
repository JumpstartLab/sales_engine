class Customer
  attr_accessor :cust_id,
                :first_name,
                :last_name,
                :create_date,
                :update_date

  def initialize(customer)
    self.cust_id = customer[:id].to_s
    self.first_name = customer[:first_name].to_s
    self.last_name = customer[:last_name].to_s
    self.create_date = customer[:created_at].to_s
    self.update_date = customer[:updated_at].to_s

  end
end