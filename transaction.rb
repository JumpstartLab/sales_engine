require 'csv'
require 'database'

class Transaction
  attr_accessor :id, :invoice_id, :credit_card_number, :credit_card_expiration_date, :result, :created_at, :updated_at

  def initialize(attributes)
    self.id = attributes[:id]
    self.invoice_id = attributes[:invoice_id]
    self.credit_card_number = attributes[:credit_card_number]
    self.credit_card_expiration_date = attributes[:credit_card_expiration_date]
    self.result = attributes[:result]
    self.created_at = attributes[:created_at]
    self.updated_at = attributes[:updated_at]
  end

  def self.load(filename="transactions.csv")
    puts "Loading transactions..."

    file = CSV.open(filename, { :headers => true,
                                :header_converters => :symbol})
    Database.instance.transaction_list = file.collect{ |line| Transaction.new(line) }
  end

  def self.transaction_list=(foo)
    Database.instance.transaction_list = foo
  end

  def self.find_by_id(id)
    Database.instance.transaction_list.detect{ |transaction| transaction.id == id }
  end

  def invoice
    Invoice.find_by_id(self.invoice_id)
  end

end