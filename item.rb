require './merchant'
require './invoice_item'

class Item
 
 # id,name,description,unit_price,merchant_id,created_at,updated_at

  ITEMS         = []
  CSV_OPTIONS   = {:headers => true, :header_converters => :symbol}
  ITEM_DATA     = "items.csv"

  attr_accessor :id, :name, :description, :unit_price, :merchant_id, 
                :created_at, :updated_at

  def initialize(attributes={})
    self.id           = attributes[:id]
    self.name         = attributes[:name]
    self.description  = attributes[:description]
    self.unit_price   = attributes[:unit_price]
    self.merchant_id  = attributes[:merchant_id]
    self.created_at   = attributes[:created_at]
    self.updated_at   = attributes[:updated_at]
  end

  def self.load_data
    item_file = CSV.open(ITEM_DATA, CSV_OPTIONS)
    item_file.collect do |i| 
      ITEMS << Item.new(i)
    end
    puts "Loaded Item data."
  end

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