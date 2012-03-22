# require './item'
# require './invoice'
# require 'csv'
# require './sales_engine'
# require './customer' should only need to reference invoices > transactions
module SalesEngine
  class Merchant
    #extend SalesEngine
    
    #MERCHANTS     = []
    #CSV_OPTIONS   = {:headers => true, :header_converters => :symbol}
    #MERCHANT_DATA = "merchants.csv"

    attr_accessor :id, :name, :created_at, :updated_at

    def initialize(attributes={})
      if !attributes.nil? 
        self.id         = attributes[:id]
        self.name       = attributes[:name]
        self.created_at = attributes[:created_at]
        self.updated_at = attributes[:updated_at]
      end
    end

    # def self.load_data
    #   merch_file = CSV.open(MERCHANT_DATA, CSV_OPTIONS)
    #   merch_file.collect do |m| 
    #     MERCHANTS << Merchant.new(m)
    #   end
    #   #puts "Loaded Merchant data."
    # end

    def items
      #returns a collection of Item instances associated with that merchant for the products they sell

    end

    def invoices
      # returns a collection of Invoice instances associated with that merchant from their known orders
    end

    def self.most_revenue(num_of_merchants)
      # returns the top x merchant instances ranked by total revenue

    end

    def self.items(num_of_merchants)
      # returns the top x merchant instances ranked by total number of items sold
    end

    def self.revenue(date)
      # returns the total revenue for that date across all merchants
    end

    def revenue(date=nil)
      #if date?
        #revenue(date) returns the total revenue that merchant for a specific date
      #else
        # returns the total revenue for that merchant across all transactions
    end

    def favorite_customer
      #favorite_customer returns the Customer who has conducted the most transactions
      # should reference invoices > transactions
    end

    def customers_with_pending_invoices
      #customers_with_pending_invoices returns a collection of Customer instances which have pending (unpaid) invoices
    end

  end
end