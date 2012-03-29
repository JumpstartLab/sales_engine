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
      @unit_price = BigDecimal.new(attributes[:unit_price].to_s)

      validate_attributes
    end

    def revenue
      BigDecimal.new(unit_price.to_s) * BigDecimal.new(quantity.to_s)
    end

    def name
      item.name
    end

    def item
      Item.find_by_id(item_id)
    end

    private

    def validate_attributes
      validates_numericality_of :quantity, @quantity, :integer => true
    end
  end
end
