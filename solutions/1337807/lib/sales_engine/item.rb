require 'model'

module SalesEngine
  class Item
    include Model
    attr_reader :name, :description, :unit_price, :merchant_id

    def initialize(attributes)
      super(attributes)
      
      @name = attributes[:name]
      @description = attributes[:description]
      @unit_price = clean_float(attributes[:unit_price])
      @merchant_id = clean_integer(attributes[:merchant_id])

      validate_attributes
    end

    def merchant
      @merchant ||= Merchant.find(@merchant_id)
    end

    private

    def validate_attributes
      validates_presence_of :name, @name
      validates_presence_of :description, @description
      validates_numericality_of :unit_price, @unit_price
      validates_numericality_of :merchant_id, @merchant_id, :integer => true
    end
  end
end
