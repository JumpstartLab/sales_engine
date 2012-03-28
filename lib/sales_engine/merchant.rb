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
      @items ||= Item.find_all_by_merchant_id(self.id)
    end

    def invoices
      @invoices ||= Invoice.find_all_by_merchant_id(self.id)
    end

    def revenue(date=nil)
      
    end

  end
end
