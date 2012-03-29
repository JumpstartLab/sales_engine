require 'sales_engine/randomize'
require 'sales_engine/searchable'

module SalesEngine
  class Merchant

    extend Randomize  
    extend Searchable

    attr_accessor :id, :name, :created_at, :updated_at

    def initialize(attributes)
      self.id         = attributes[:id]
      self.name       = attributes[:name]
      self.created_at = attributes[:created_at]
      self.updated_at = attributes[:updated_at]
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

    # def revenue
    #   result = 0
    #   invoices.each do |invoice|
    #     result += invoice.total_amount
    #   end
    # end

    def self.most_revenue(param)
      @most_revenue ||= collection.sort_by { |m| m.revenue }
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

    # def most_items()
    #   # returns the top x merchant instances ranked by total number of items sold
    # end

    def revenue(*date)
      if date.nil?
        result = 0
        invoices.each do |invoice|
          result += invoice.total_amount
        end
      else
        revenue_by_date(date)
      end
    end

    # def favorite_customer
    #   # returns the Customer who has conducted the most transactions
    # end

    # def customers_with_pending_invoices
    #   # returns a collection of Customer instances which have pending (unpaid) invoices
    # end

  end
end