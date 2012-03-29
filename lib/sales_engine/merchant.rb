require 'sales_engine/randomize'
require 'sales_engine/searchable'
require 'bigdecimal'

module SalesEngine
  class Merchant
    extend Randomize
    extend Searchable

    attr_accessor :id, :name, :created_at, :updated_at

    def initialize(attributes)
      self.id         = attributes[:id].to_i
      self.name       = attributes[:name]
      self.created_at = Date.parse(attributes[:created_at])
      self.updated_at = Date.parse(attributes[:updated_at])
    end

    class << self
      [:id, :name, :created_at,
       :updated_at].each do |attribute|
        define_method "find_by_#{attribute}" do |input|
          find_by_(attribute, input)
        end
      end

      [:id, :name, :created_at,
       :updated_at].each do |attribute|
        define_method "find_all_by_#{attribute}" do |input|
          find_all_by_(attribute, input)
        end
      end
    end

    def self.collection
      database.merchants
    end

    def self.database
      SalesEngine::Database.instance
    end

    def database
      @database ||= SalesEngine::Database.instance
    end

    def database=(input)
      @database = input
    end

    def items
      items = SalesEngine::Database.instance.items
      results = items.select { |item| item.merchant_id == self.id }
    end

    def invoices
      Invoice.find_all_by_merchant_id(self.id)
    end

    def invoice_items
      database.invoiceitems.select{ |ii| get_invoice_ids.include?(invoices) }
    end

    def get_invoice_ids
      invoices.map { |i| i.id }
    end

    def invoice_item_revenue
      invoice_items.map { |ii| ii.total }
    end

    def revenue(date=nil)
      if date
        revenue_by_date(date)
      else
        result = 0
        invoices.each do |invoice|
          result += invoice.total_amount
        end
        result.round(2)
      end
    end

    def self.most_revenue(param)
      @most_revenue ||= collection.sort_by do |m| 
        m.get_revenue
      end.last(param).reverse
    end

    def get_revenue
      @revenue ||= paid_invoices.inject(0) do |v, i|
        v + i.total_amount
      end
    end

    def paid_invoices
      invoices.select do |i|
        i if i.paid?
      end
    end

    def self.revenue(date) 
      result = 0
      collection.each do |merchant|
        result += merchant.revenue_by_date(date)
      end
      result
    end

    def revenue_by_date(date)
      result = 0
      invoices.each do |invoice|
        result += invoice.revenue_by_date(date)
      end
      result
    end

    def self.most_items(param)
      collection.sort_by do |m|
        m.add_items
      end.last(param).reverse
    end

    def add_items
      paid_invoices.inject(0) do |acc,num|
        acc + num.total_items
      end
    end

    def favorite_customer
      grouped_by_customer = paid_invoices.group_by{|invoice| invoice.customer}
      std_and_gpd_by_cstmr = grouped_by_customer.sort_by do |customer,invoices|
        invoices.count
      end
      customer_and_invoices = std_and_gpd_by_cstmr.last
      customer = customer_and_invoices.first
    end

    def customers_with_pending_invoices
      results = []
      invoices.map(&:customer_id).uniq.each do |cust_id|
        customer = SalesEngine::Customer.find_by_id(cust_id)
        results << customer if customer.has_pending_invoices?(self.id)
      end
      results
    end
  end
end