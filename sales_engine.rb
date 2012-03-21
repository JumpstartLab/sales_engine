require 'csv'
require 'singleton'
require './merchant'
require './item'
require './invoice'

class SalesEngine
  include Singleton
  CSV_OPTIONS = {:headers => true, :header_converters => :symbol}
  attr_accessor :merchants, :items, :invoices

  def initialize
    clear_all_data
  end

  def clear_all_data
    self.merchants = []
    self.items = []
    self.invoices = []
  end

  def get_random_record(class_name)
    case class_name
    when 'merchant' then self.merchants[rand(self.merchants.count)]
    end
  end

  def load_merchants_data(filename)
    @file = CSV.open(filename, CSV_OPTIONS)
    self.merchants = @file.collect {|line| Merchant.new(line) }
  end

  def load_items_data(filename)
    @file = CSV.open(filename, CSV_OPTIONS)
    self.items = @file.collect {|line| Item.new(line) }
  end

  def load_invoices_data(filename)
    @file = CSV.open(filename, CSV_OPTIONS)
    self.invoices = @file.collect {|line| Invoice.new(line) }
  end

  def add_merchant_to_list(merchant)
    self.merchants << merchant
  end

  def add_item_to_list(item)
    self.items << item
  end

  def add_invoice_to_list(invoice)
    self.invoices << invoice
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

  def find_all_invoices_by_merchant_id(id)
    invoice_list = []
    self.invoices.each do |invoice| 
      if invoice && invoice.merchant_id && invoice.merchant_id == id
        invoice_list << invoice
      end
    end
    invoice_list.sort_by { |invoice| invoice.merchant_id }
  end
end