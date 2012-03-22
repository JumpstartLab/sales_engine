require './lib/sales_engine/model'

module SalesEngine
  class Item
    include Model
    attr_reader :name, :description, :unit_price, :merchant

    def initialize(attributes)
      validate_attributes(attributes)

      @name = attributes[:name]
      @description = attributes[:description]
      @unit_price = attributes[:unit_price]
      @merchant = attributes[:merchant]
    end

    private

    def validate_attributes(attributes)
      validate_name(attributes[:name])
      validate_description(attributes[:description])
      validate_unit_price(attributes[:unit_price])
      validate_merchant(attributes[:merchant])
    end

    def validate_name(name)
      unless name.to_s.empty?
        true
      else
        name_error_msg = "Items must have a name"
        raise ArgumentError, name_error_msg
      end
    end

    def validate_description(description)
      unless description.to_s.empty?
        true
      else
        description_error_msg = "Items must have a description"
        raise ArgumentError, description_error_msg
      end
    end

    def validate_unit_price(unit_price)
      unless unit_price.to_s.empty? || not(unit_price.is_a?(Numeric))
        true
      else
        unit_price_error_msg = "Items must have a unit price"
        raise ArgumentError, unit_price_error_msg
      end
    end

    def validate_merchant(merchant)
      if merchant.is_a? Merchant
        true
      else
        merchant_error_msg = "Items must have a merchant"
        raise ArgumentError, merchant_error_msg
      end
    end
  end
end
