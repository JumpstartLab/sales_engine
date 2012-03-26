module SalesEngine
  class Merchant
  
    extend Searchable

    attr_accessor :id, :name, :created_at, :updated_at

    def initialize(attributes)
      self.id = attributes[:id]
      self.name = attributes[:name]
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

    # def items
    #   # returns a collection of Item instances associated with that merchant for the products they sell
    # end

    # def invoices
    #   # returns a collection of Invoice instances associated with that merchant from their known orders
    # end

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