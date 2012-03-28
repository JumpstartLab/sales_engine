require 'model'

module SalesEngine
  class Customer
    include Model

    attr_reader :first_name, :last_name

    def initialize(attr)
      super(attr)

      @first_name = attr[:first_name]
      @last_name = attr[:last_name]

      validates_presence_of :first_name, attr[:first_name]
      validates_presence_of :last_name, attr[:last_name], :allow_blank => true
    end
  end
end
