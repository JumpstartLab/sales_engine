require './lib/model'

module SalesEngine
  class Customer
    include Model

    attr_reader :first_name, :last_name

    def initialize(attributes)
      super(attributes)

      @first_name = attributes[:first_name]
      @last_name = attributes[:last_name]

      first_error_msg = "A customer must have a first name."
      raise ArgumentError, first_error_msg unless valid_name? @first_name
      
      last_error_msg = "A customer must have a last name."
      raise ArgumentError, last_error_msg unless valid_name? @last_name
    end

    private

    def valid_name?(name)
      true unless name.to_s.empty?
    end
  end
end
