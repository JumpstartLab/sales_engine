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
      SalesEngine::Database.instance.merchants
    end

    def items
      items = SalesEngine::Database.instance.items
      results = items.select { |item| item.merchant_id == self.id }
    end

    def invoices
      invoices = SalesEngine::Database.instance.invoices
      results = invoices.select { |invoice| invoice.merchant_id == self.id }
    end

    def merchants_revenue
      self.invoice_items.inject(0){ |acc,num| num.revenue + acc }
    end

    # def most_revenue()
    #   # returns the top x merchant instances ranked by total revenue
    # end

    # def most_items()
    #   # returns the top x merchant instances ranked by total number of items sold
    # end

    # def revenue(date)
    #   # returns the total revenue for that date across all merchants
    # end

    # def revenue
    #   # returns the total revenue for that merchant across all transactions
    # end

    # def favorite_customer
    #   # returns the Customer who has conducted the most transactions
    # end

    # def customers_with_pending_invoices
    #   # returns a collection of Customer instances which have pending (unpaid) invoices
    # end

  end
end