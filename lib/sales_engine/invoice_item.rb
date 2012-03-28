require 'model'

module SalesEngine
  class InvoiceItem
    include Model

    attr_reader :item, :invoice, :quantity, :unit_price

    def initialize(attributes)
      super(attributes)

      @item = attributes[:item]
      @invoice = attributes[:invoice]
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
