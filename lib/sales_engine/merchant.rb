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

    def initialize(attributes = {})
      define_attributes(attributes)
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
        revenue = invoices.inject(0) do |sum, invoice|
          sum += invoice.revenue
        end
        revenue = BigDecimal.new(revenue)
      end
    end

    def invoices
      Invoice.find_all_by_merchant_id(self.id)
    end

    def items
      Item.find_all_by_merchant_id(self.id)
    end

  end

end







