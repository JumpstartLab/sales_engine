require './lib/sales_engine/model'

module SalesEngine
  class Customer
    include Model

    attr_reader :first_name, :last_name

    def initialize(attributes)
      super(attributes)

      @first_name = attributes[:first_name]
      @last_name = attributes[:last_name]

      validates_presence_of :first_name, attributes[:first_name]
      validates_presence_of :last_name, attributes[:last_name], :allow_blank => true
    end
  end
end
