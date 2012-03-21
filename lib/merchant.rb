require './class_methods'
require "./item.rb"
require "./invoice.rb"
require "date"
require "bigdecimal"


class Merchant
  ATTRIBUTES = [:id, :name, :created_at, :updated_at]
  extend SearchMethods
  extend AccessorBuilder

  def initialize(attributes = {})
    define_attributes(attributes)
  end

  def revenue(date=nil)
    if date
      invoices.inject(BigDecimal.new(0)) do |total_revenue, invoice|
        if invoice.date == date
          total_revenue += invoice.revenue
        end
      end
    else
      invoices.inject(BigDecimal.new(0)) do |total_revenue, invoice|
        total_revenue += invoice.revenue
      end
    end
  end

  def invoices
    Invoice.find_all_by_merchant_id(self.id)
  end

  def items
    Item.find_all_by_merchant_id(self.id)
  end

end










