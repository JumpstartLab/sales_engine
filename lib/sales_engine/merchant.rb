require 'class_methods'
require "item.rb"
require "invoice.rb"
require "date"
require "bigdecimal"

module SalesEngine
  class Merchant
    ATTRIBUTES = [:id, :name, :created_at, :updated_at]
    extend SearchMethods
    include AccessorBuilder
    attr_writer :revenue

    def initialize(attributes = {})
      define_attributes(attributes)
      calc_revenue

    end

    def calc_revenue
      revenue = 0
      revenue = invoices.inject(0) do |sum, invoice|
        sum += invoice.revenue
      end
      @revenue = BigDecimal.new(revenue)
    end

    def revenue(date=nil)
      revenue = 0
      if date
        revenue = invoices.inject(0) do |sum, invoice|
          if invoice.created_at == date
            sum += invoice.revenue
          end
          revenue = BigDecimal.new(revenue)
        end
      else
        @revenue
      end
    end

    def invoices
      Invoice.find_all_by_merchant_id(self.id)
    end

    def items
      Item.find_all_by_merchant_id(self.id)
    end

    def self.most_revenue(number)
      sorted = Database.instance.merchant.sort_by {|merchant| -merchant.revenue}
      sorted.slice(0...number)
    end

  end

end







