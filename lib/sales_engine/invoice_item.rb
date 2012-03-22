module SalesEngine
  class InvoiceItem
    attr_accessor :id, :item_id, :invoice_id, :quantity, :unit_price, :created_at, :updated_at

    def initialize(attributes)
      self.id = attributes[:id]
      self.item_id = attributes[:item_id]
      self.invoice_id = attributes[:invoice_id]
      self.quantity =   BigDecimal.new(attributes[:quantity])
      self.unit_price = BigDecimal.new(attributes[:unit_price])
      self.created_at = attributes[:created_at]
      self.updated_at = attributes[:updated_at]
    end

    def self.total_revenue
      total_revenue = BigDecimal.new("0")
      SalesEngine::Database.instance.invoice_item_list.each do |i_i|
        total_revenue += i_i.quantity * i_i.unit_price
      end
      total_revenue
    end
  end
end