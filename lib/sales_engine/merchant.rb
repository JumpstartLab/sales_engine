require 'sales_engine/item'
require 'sales_engine/model'
require 'bigdecimal'

class SalesEngine
  class Merchant
    ATTRIBUTES = %w(id created_at updated_at name)
    attr_accessor :id

    def initialize(attributes)
      super(attributes)
      @name = attributes[:name]
    end

    def self.finder_attributes
      ATTRIBUTES
    end

    include Model

    def items
      SalesEngine::Database.instance.items.select do |item|
        item.merchant_id == @id
      end
    end

    def invoices=(input)
      @invoices = input
    end

    def invoices
      @invoices || SalesEngine::Database.instance.invoices.select do |invoice|
        invoice.merchant_id == @id
      end
    end

    def revenue
      sum = 0
      invoices.each do |invoice|
        sum = sum + invoice.total
      end
      b = BigDecimal.new(sum).truncate(2)
    end

    def customers
      invoices.collect{ |invoice| invoice.customer }
    end

    def favorite_customer
      grouped_by_customer = invoices.group_by{|invoice| invoice.customer}
      sorted_and_grouped_by_customer = grouped_by_customer.sort_by{|customer, invoices| invoices.count }
      customer_and_invoices = sorted_and_grouped_by_customer.last
      customer = customer_and_invoices.first
    end
  end
end
