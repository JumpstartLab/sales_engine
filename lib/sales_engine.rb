$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(File.dirname(__FILE__)),'lib'))).uniq!

require 'sales_engine/customer'
require 'sales_engine/database'
require 'sales_engine/invoice'
require 'sales_engine/invoice_item'
require 'sales_engine/item'
require 'sales_engine/merchant'
require 'sales_engine/transaction'
require 'sales_engine/model'

class SalesEngine
  def self.startup
    puts "starting up!"
  end
end