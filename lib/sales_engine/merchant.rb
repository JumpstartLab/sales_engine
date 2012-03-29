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

    def revenue
      @revenue ||= Invoice.find_all_by_merchant_id(id).map(&:revenue).inject(:+)
    end

    def self.revenue(date=nil)
      Invoice.find_all_by_created_at_date(date).map(&:revenue).inject(:+)      
    end

    def self.most_revenue(n)
      merchants_revenue = {}

      Merchant.find_all.each do |merchant|
        merchants_revenue[merchant] = merchant.revenue
      end

      merchants_revenue.sort_by { |k,v| v }.map(&:first)[0...n]
    end
  end
end
