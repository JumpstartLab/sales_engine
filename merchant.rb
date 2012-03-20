require "./item.rb"
require "./invoice.rb"
require "date"
require "bigdecimal"


class Merchant
  attr_accessor  :id, :name, :created_at, :updated_at
  def initialize (attributes = {})
    define_attributes(attributes)
  end

  def define_attributes (attributes)  
    attributes.each do |key, value|
      send("#{key}=",value)
    end
  end

  def revenue (date=nil)
    if date
      invoices.inject (BigDecimal.new(0)) do |total_revenue, invoice|
        if invoice.date == date
          total_revenue += invoice.revenue
        end
      end
    else
      invoices.inject (BigDecimal.new(0)) do |total_revenue, invoice|
        total_revenue += invoice.revenue
      end
    end
  end

  def invoices=(value)
    @invoices = value
  end

  def invoices
    @invoices ||= []
  end

  def items=(value)
    @items = value
  end

  def items
    @items ||= []
  end

  def add_item(item)
    self.items << item
  end

  def add_invoice(invoice)
    self.invoices << invoice
  end

  def self.find_by_id(id)
    Merchant.new
  end

end










