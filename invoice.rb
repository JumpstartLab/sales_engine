require "./class_methods"
class Invoice
  ATTRIBUTES = ["merchant_id","id","customer_id","status","created_at", "updated_at"]
  extend SearchMethods


  def initialize(attributes = {})
    define_attributes(attributes)
  end

  def transactions
    Transactions.find_all_by_invoice_id(id)
  end
  def define_attributes (attributes)  
    attributes.each do |key, value|
      send("#{key}=",value)
    end
  end
end