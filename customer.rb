class Customer
  attr_accessor :id, :first_name, :last_name, :created_at, :updated_at

  CUSTOMER_ATTS = [
   "id",
   "first_name",
   "last_name",
   "created_at",
   "updated_at"
   ]

  def initialize(attributes)
    self.id = attributes[:id]
    self.first_name = attributes[:first_name]
    self.last_name = attributes[:last_name]
    self.created_at = attributes[:created_at]
    self.updated_at = attributes[:updated_at]
  end

  CUSTOMER_ATTS.each do |att|
    define_singleton_method ("find_by_" + att).to_sym do |param|
      Database.instance.customer_list.detect{ |customer| customer.send(att.to_sym) == param }
    end
  end
end