require './invoice'
require './transaction'
require './merchant'

class Customer

  def invoices
    #invoices returns a collection of Invoice instances associated with this object.
  end

  def transactions
    #transactions returns an array of Transaction instances associated with the customer
  end

  def favorite_merchant
    #favorite_merchant returns an instance of Merchant where the customer has conducted the most transactions
  end

end