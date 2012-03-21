require './lib/model'

module SalesEngine
  class Item
    include Model
    attr_reader :name, :description, :unit_price

    def initialize(attributes)
      @name = attributes[:name]
      @description = attributes[:description]
      @unit_price = attributes[:unit_price]

      name_error_msg = "Items must have a name"
      raise ArgumentError, name_error_msg unless valid_name?(@name)

      description_error_msg = "Items must have a description"
      raise ArgumentError, description_error_msg unless valid_description?(@description)

      unit_price_error_msg = "Items must have a unit price"
      raise ArgumentError, unit_price_error_msg unless valid_unit_price?(@unit_price)
    end

    private

    def valid_name?(name)
      true unless name.to_s.empty?
    end

    def valid_description?(description)
      true unless description.to_s.empty?
    end

    def valid_unit_price?(unit_price)
      true unless unit_price.to_s.empty? || not(unit_price.is_a?(Numeric))
    end
  end
end