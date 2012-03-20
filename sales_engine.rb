require 'csv'
require './merchant'
require './item'

class SalesEngine
  CSV_OPTIONS = {:headers => true, :header_converters => :symbol}
  attr_accessor :merchants, :items

  def initialize
    self.merchants = []
    self.items = []
  end

  def load_merchants_data(filename)
    @file = CSV.open(filename, CSV_OPTIONS)
    self.merchants = @file.collect {|line| Merchant.new(line) }
  end

  def load_items_data(filename)
    @file = CSV.open(filename, CSV_OPTIONS)
    self.items = @file.collect {|line| Item.new(line) }
  end

  def add_merchant_to_list(merchant)
    self.merchants << merchant
  end

  def add_item_to_list(item)
    self.items << item
  end

  def find_all_items_by_merchant_id(id)
    item_list = []
    self.items.each do |item| 
      if item && item.merchant_id && item.merchant_id == id
        item_list << item
      end
    end
    item_list.sort_by { |item| item.merchant_id }
  end
end