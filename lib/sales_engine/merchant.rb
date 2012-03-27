require 'class_methods'
require "item.rb"
require "invoice.rb"
require "date"
require "awesome_print"
require "bigdecimal"

module SalesEngine
  class Merchant
    ATTRIBUTES = [:id, :name, :created_at, :updated_at]
    extend SearchMethods
    include AccessorBuilder

    def initialize(attributes = {})
      define_attributes(attributes)
      Database.instance.merchant[id.to_i][:self] = self
      Database.instance.all_merchants[id.to_i - 1] = self
    end

    def all_merchants
      Database.instance.all_merchants
    end

    def invoices
      @invoices ||= Database.instance.merchant[id.to_i][:invoices]
    end

    def items
      @items ||= Database.instance.merchant[id.to_i][:items]
    end

    def items_sold
      @items_sold ||= calc_items_sold
    end

    def revenue(date=nil, end_date=date)
      if date
        @revenue ||= BigDecimal.new(calc_revenue_by_date(date, end_date))
      else
        @revenue ||= BigDecimal.new(calc_revenue)
      end
    end

    def pending_invoices
      self.invoices.select do |invoice|
        not invoice.successful?
      end
    end

    def customers_with_pending_invoices
      pending_invoices.collect do |invoice|
        invoice.customer
      end
    end

    def calc_revenue
      revenue = invoices.inject(0) do |sum, invoice|
        sum += invoice.revenue
      end
      BigDecimal.new(revenue)
    end

    def calc_revenue_by_date (date=nil, end_date=date)
      revenue = invoices.inject(0) do |sum, invoice|
        if invoice.created_at >= date && invoice.created_at <= end_date
          sum += invoice.revenue
        end
        sum
      end
      BigDecimal.new(revenue)
    end

    def calc_items_sold
      items_sold = 0
      items.inject(0) do |quantity, item|
        quantity += item.invoice_items.inject(0) do |q, i|
          q += i.quantity.to_i
        end
      end
    end

    def favorite_customer
      transaction_counts = Hash.new {|hash, key| hash[key] = 0 }
      highest = 0
      top_customer = nil
      self.invoices.each do |invoice|
        if invoice.successful?
          transaction_counts[invoice.customer_id] += 1
          count = transaction_counts[invoice.customer_id]
          if count > highest
            highest = count
            top_customer = invoice.customer
          end
        end
      end
      top_customer
    end

    def self.revenue(date, end_date=date)
      total_revenue = 0
      all_merchants.each do |merchant|
        total_revenue += merchant.revenue(date,end_date)
      end
      total_revenue
    end

    def self.dates_by_revenue(x = -1)
      accumulator = Hash.new {|hash, key| hash[key] = 0 }
      all_merchants.each do |merchant|
        merchant.invoices.each do |invoice|
          accumulator[invoice.created_at] += invoice.revenue
        end
      end
      sorted = accumulator.sort_by do |date, count|
        -count
      end
      dates_array = sorted.collect do |date, value|
        date
      end
      dates_array.slice(0...x)
    end

    def self.most_revenue(number)
      sorted = Database.instance.all_merchants.sort_by do |merchant| 
        -merchant.revenue
      end
      sorted.slice!(0...number)
    end

    def self.most_items(number)
      sorted = Database.instance.all_merchants.sort_by do |merchant|
        -merchant.items_sold
      end
      sorted.slice!(0...number)
    end
  end
end







