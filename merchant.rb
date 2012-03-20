require './item'
require './invoice'
require './customer'

class Merchant

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
  end

  def customers_with_pending_invoices
    #customers_with_pending_invoices returns a collection of Customer instances which have pending (unpaid) invoices
  end

end