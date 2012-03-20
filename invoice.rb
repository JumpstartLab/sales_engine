require 'csv'
require 'ruby-debug'

class Invoice

  attr_accessor :id, :customer_id, :merchant_id, :status, :created_at, :updated_at

  @@invoice_list = [ ]

  def initialize(attributes)
    self.id = attributes[:id]
    self.customer_id = attributes[:customer_id]
    self.merchant_id = attributes[:merchant_id]
    self.status = attributes[:status]
    self.created_at = attributes[:created_at]
    self.updated_at = attributes[:updated_at]
  end

  def self.load_me(filename="invoices.csv")
    puts "Loading invoices..."
    file = CSV.open(filename, { :headers => true,
                                :header_converters => :symbol})
    self.invoice_list = file.collect{ |line| Invoice.new(line) }
  end

  def self.invoice_list=(foo)
    @@invoice_list = foo
  end

  def self.find_by_id(id)
    @@invoice_list.detect{ |invoice| invoice.id == id }
  end
end