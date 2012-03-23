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
    attr_reader :items, :items_sold, :invoices

    def initialize(attributes = {})
      define_attributes(attributes)
      update
    end

    def update
      calc_invoices
      calc_items
      calc_revenue
      calc_items_sold
    end

    def calc_revenue
      revenue = 0
      revenue = invoices.inject(0) do |sum, invoice|
        sum += invoice.revenue
      end
      @revenue = BigDecimal.new(revenue)
    end

    def revenue(date=nil)
      total_revenue = 0
      if date
        total_revenue = invoices.inject(0) do |sum, invoice|
          if invoice.created_at == date
            sum += invoice.revenue
          end
        end
        BigDecimal.new(total_revenue)
      else
        @revenue
      end
    end


    def calc_invoices
      @invoices = Invoice.find_all_by_merchant_id(self.id)
    end

    def calc_items_sold
      items_sold = 0
      items_sold = @items.inject(0) do |quantity, item|
        quantity += item.invoice_items.inject(0) do |q, i|
          q += i.quantity.to_i
        end
      end
      @items_sold = items_sold
    end

    def calc_items
      @items = Item.find_all_by_merchant_id(self.id)
    end

    def self.most_revenue(number)
      sorted = Database.instance.merchant.sort_by {|merchant| -merchant.revenue}
      sorted.slice(0...number)
    end

    def self.most_items(number)
      sorted = Database.instance.merchant.sort_by {|merchant| -merchant.items_sold}
      sorted.slice(0...number)
    end
  end
end







