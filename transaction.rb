class Transaction
  attr_accessor :id, :invoice_id, :credit_card_number,
  :credit_card_expiration_date, :result, :created_at, :updated_at

  def initialize (attributes = {})
    define_attributes(attributes)
  end

  def define_attributes (attributes)  
    attributes.each do |key, value|
      send("#{key}=",value)
    end
  end

  def invoice
    Invoice.find_by_id(invoice_id)
  end



end