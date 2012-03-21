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

  def invoices=(value)
    @invoices = value
  end

  def invoices
    @invoices ||= []
  end

  def transactions=(value)
    @transactions = value
  end

  def transactions
    @transactions ||= []
  end

  def add_transaction(transaction)
    self.transactions << transaction
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