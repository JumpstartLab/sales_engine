require 'model'

module SalesEngine
  class Merchant
    include Model

    attr_reader :name

    def initialize(attributes)
      super(attributes)

      @name = attributes[:name]

      validates_presence_of :name, @name
    end

    def name=(name)
      @name = name
      update!
    end

    def items
      Item.find_all_by_merchant_id(self.id)
    end

    def invoices
      Invoice.find_all_by_merchant_id(self.id)
    end
  end
end
