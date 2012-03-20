require './record'

class Merchant < Record
  attr_accessor :name

  def initialize(attributes={})
    super
    self.name = attributes[:name]
  end

  def items(sales_engine)
    sales_engine.find_all_items_by_merchant_id(self.id)
  end

  def invoices(sales_engine)
      sales_engine.find_all_invoices_by_merchant_id(self.id)
  end
end