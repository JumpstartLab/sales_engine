require './invoice'
require './transaction'
# require './merchant' should only need to reference invoices > transactions?

class Customer
  # id,first_name,last_name,created_at,updated_at

  def invoices
    #invoices returns a collection of Invoice instances associated with this object.
  end

  def transactions
    #transactions returns an array of Transaction instances associated with the customer
  end

  def favorite_merchant
    #favorite_merchant returns an instance of Merchant where the customer has conducted the most transactions
    # will reference invoices > transactions class to determine count
  end

end