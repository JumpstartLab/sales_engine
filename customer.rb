class Customer
  ATTRIBUTES = [:id, :first_name, :last_name, :created_at, :updated_at]
  extend SearchMethods
  def initialize (attributes = {})
    define_attributes(attributes)
  end

  def define_attributes (attributes)  
    attributes.each do |key, value|
      send("#{key}=",value)
    end
  end

  def invoices
    Invoice.find_all_by_customer_id(self.id)
  end

  def transactions
    Transaction.find_all_by_customer_id(self.id)
  end

  def favorite_merchant
    successful = successful_transactions
    merchant_hash = Hash.new(0)
    successful.each do |transaction|
      merchant_hash[transaction.merchant.id] += 1
    end
    sorted_array = merchant_hash.sort_by do |key, value|
      value
    end
    merchant_id = sorted_array.first[0]
    Merchant.find_by_id(merchant_id)
  end

  def successful_transactions
    self.transactions.select { transaction.successful? }
  end


end