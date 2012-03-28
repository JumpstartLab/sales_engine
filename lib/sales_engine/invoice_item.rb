require 'model'

module SalesEngine
  class InvoiceItem
    include Model

    attr_reader :item_id, :invoice_id, :quantity, :unit_price

    def initialize(attributes)
      super(attributes)
      @item_id = clean_integer(attributes[:item_id])
      @invoice_id = clean_integer(attributes[:invoice_id])
      @quantity = clean_integer(attributes[:quantity])
      @unit_price = clean_float(attributes[:unit_price])

      validate_attributes
    end

    private

    def validate_attributes
      validates_numericality_of :quantity, @quantity, :integer => true
      validates_numericality_of :unit_price, @unit_price
    end
  end
end
