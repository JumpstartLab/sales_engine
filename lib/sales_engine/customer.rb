require './lib/sales_engine/model'

module SalesEngine
  class Customer
    include Model

    attr_reader :first_name, :last_name

    def initialize(attributes)
      super(attributes)

      @first_name = attributes[:first_name]
      @last_name = attributes[:last_name]

      validate_attributes(attributes)
    end

    private

    def validate_attributes(attributes)
      validate_first_name(attributes[:first_name])
      validate_last_name(attributes[:last_name])
    end
    
    def validate_first_name(first_name)
      first_error_msg = "A customer must have a first name."
      raise ArgumentError, first_error_msg unless valid_name? @first_name
    end

    def validate_last_name(last_name)
      last_error_msg = "A customer must have a last name."
      raise ArgumentError, last_error_msg unless valid_name? @last_name
    end

    def valid_name?(name)
      true unless name.to_s.empty?
    end
  end
end
