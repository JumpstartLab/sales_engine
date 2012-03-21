require 'class_methods'
require 'singleton'

class Database 
  ATTRIBUTES = [:customers, :items, :invoice_items,
                :merchants, :transactions, :invoices]
  include Singleton
  include AccessorBuilder

  def initialize
    ATTRIBUTES.each do |attribute|
      send(attribute, Array.new)
    end
  end

end