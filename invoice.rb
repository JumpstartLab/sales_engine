require './transaction'
require './customer'
require './invoice_item'
require './item'

class Invoice

  # invoice = Invoice.new(:customer_id => customer, :merchant_id => merchant, :status => "shipped", :items => [item1, item2, item3], :transaction => transaction)

  def transactions
    # returns a collection of associated Transaction instances
  end

  def invoice_items
    #invoice_items returns a collection of associated InvoiceItem instances
  end

  def items
    #items returns a collection of associated Items by way of InvoiceItem objects
  end

  def customer
    #customer returns an instance of Customer associated with this object
  end

  def charge 
    # invoice.charge(:credit_card_number => "4444333322221111", :credit_card_expiration => "10/13", :result => "success")
    # will call new instance of Transaction
  end

end