require 'csv'

class Customer
  attr_accessor :id, :first_name, :last_name, :created_at, :updated_at

  def initialize(attributes)
    self.id = attributes[:id]
    self.first_name = attributes[:first_name]
    self.last_name = attributes[:last_name]
    self.created_at = attributes[:created_at]
    self.updated_at = attributes[:updated_at]
  end

  def invoices
    # returns a collection of Invoice instances associated with this object
  end

end