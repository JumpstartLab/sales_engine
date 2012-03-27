require 'model'

module SalesEngine
  class Item
    include Model
    attr_reader :name, :description, :unit_price, :merchant

    def initialize(attributes)
      @name = attributes[:name]
      @description = attributes[:description]
      @unit_price = attributes[:unit_price]
      @merchant = attributes[:merchant]

      validate_attributes
    end

    private

    def validate_attributes
      validates_presence_of :name, @name
      validates_presence_of :description, @description
      validates_numericality_of :unit_price, @unit_price
      validates_presence_of :merchant, @merchant
    end
  end
end
