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

    def items_sold
      @items_sold ||= invoices.map { |invoice| invoice.invoice_item_count }.inject(:+)
    end

    def invoices
      @invoices ||= Invoice.find_all_by_merchant_id(self.id)
    end

    def revenue(date = nil)
      if date
        @revenue ||= Invoice.find_all_by_merchant_id(id).select { |invoice| invoice.created_at_date == date }.map(&:revenue).inject(:+)
      else
        @revenue ||= Invoice.find_all_by_merchant_id(id).map(&:revenue).inject(:+)
      end
      @revenue/BigDecimal.new(100.to_s)
    end

    def favorite_customer
      customer_ids = []

      invoices.each do |invoice| 
        customer_ids.push invoice.customer_id if invoice.transaction_successful?
      end
      
      Customer.find_by_id(customer_ids.uniq.map { |elem| { elem => customer_ids.count(elem) } }.sort_by { |elem| elem.values.first }.reverse.first.keys.first)
    end

    def self.revenue(date=nil)
      Invoice.find_all_by_created_at_date(date).map(&:revenue).inject(:+)      
    end

    def self.most_revenue(n)
      merchants_revenue = {}

      Merchant.find_all.each do |merchant|
        merchants_revenue[merchant] = merchant.revenue
      end

      merchants_revenue.sort_by { |k,v| v }.map(&:first).reverse[0...n]
    end

    def self.most_items(n)
      merchants_items = {}

      Merchant.find_all.each do |merchant|
        merchants_items[merchant] = merchant.items_sold
      end

      merchants_items.sort_by { |k,v| v }.map(&:first).reverse[0...n]
    end
  end
end
