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
    end

    def items
      @items ||= calc_items
    end

    def items_sold
      @items_sold ||= calc_items_sold
    end

    def invoices
      @invoices ||= calc_invoices
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
      if date && invoices.any?
        total_revenue = invoices.inject(0) do |sum, invoice|
          if invoice.created_at == date
            sum += invoice.revenue
          end
          sum
        end
        BigDecimal.new(total_revenue.to_i)
      else
        @revenue ||= calc_revenue
      end
    end


    def calc_invoices
      Invoice.find_all_by_merchant_id(self.id)
    end

    def calc_items_sold
      items_sold = 0
      items.inject(0) do |quantity, item|
        quantity += item.invoice_items.inject(0) do |q, i|
          q += i.quantity.to_i
        end
      end
    end
 
    def calc_items
      Item.find_all_by_merchant_id(self.id)
    end

    def favorite_customer
      transaction_count = Hash.new {|hash, key| hash[key] = 0 }
      highest = 0
      self.invoices.each do |invoice|
        if invoice.successful?
          transaction_count[invoice.customer_id] += 1
          count = transaction_count[invoice.customer_id]
          if count > highest
            highest = count
            top_customer = invoice.customer
          end
        end
      end
      top_customer ||= nil
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







