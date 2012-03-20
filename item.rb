require './merchant'
require './invoice_item'

class Item

  def invoice_items
    #invoice_items returns an instance of InvoiceItems associated with this object
  end

  def merchant
    #merchant returns an instance of Merchant associated with this object
  end

  def self.most_revenue(num_of_items)
    # .most_revenue(x) returns the top x item instances ranked by total revenue generated
  end

  def self.most_items(num_of_items)
    # .most_items(x) returns the top x item instances ranked by total number sold
  end

  def best_day
    # best_day returns the date with the most sales for the given item
  end

end