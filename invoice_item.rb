class InvoiceItem
  ATTRIBUTES = [:id, :invoice_id, :item_id, :quantity, :unit_price,
   :created_at, :updated_at]
   extend SearchMethods

   def initialize (attributes = {})
    define_attributes(attributes)
  end

  def define_attributes (attributes)  
    attributes.each do |key, value|
      send("#{key}=",value)
    end
  end

  def invoice
    Invoice.find_by_id(self.invoice_id)
  end

  def items
    Item.find_by_id(self.item_id)
  end
end