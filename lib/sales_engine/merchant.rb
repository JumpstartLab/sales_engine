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
      merchants_and_revenues = []

      merchants = Merchant.find_all
      merchants.each do |merchant|
        merchants_and_revenues.push [merchant.revenue, merchant]
      end

      # merchants_and_revenues.sort_by { |rev_mer| rev_mer[0] }.map(&:last)[0..n]
    end
  end
end
