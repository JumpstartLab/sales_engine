$LOAD_PATH.unshift File.join(File.dirname(__FILE__), "lib")
require 'sqlite3'
require 'loader'

module SalesEngine
  attr_accessor :elements

  def self.startup
     db = SQLite3::Database.new(':memory:')
     Database.instance.db = db
     Loader.new(db).load
  end

  def self.find_by(elements, attribute, value)
    if elements
      elements.find { |element| element.send(attribute) == value[0] }
    else
      nil
    end
  end

  def self.find_all_by(elements, attribute, value)
    if elements
      elements.select{ |element| element.send(attribute) == value[0] }
    else
      []
    end
  end

  def respond_to?(meth)
    if meth.to_s =~ /^find_by_.*$/ || meth.to_s =~ /^find_all_by_.*$/
      true
    else
      super
    end
  end

  module ClassMethods
    def method_missing(meth, *args, &block)
      if meth.to_s =~ /^find_by_(.+)$/
        SalesEngine::find_by(self.elements, $1, args)
      elsif meth.to_s =~ /^find_all_by_(.+)$/
        SalesEngine::find_all_by(self.elements, $1, args)
      else
        super
      end
    end

    def random
      if self.elements && self.elements.length > 0
        self.elements[Random.rand(self.elements.length - 1)]
      else
        nil
      end
    end
  end

  def self.included(target)
    target.extend(ClassMethods)
  end
end

require 'sales_engine/database'
require 'sales_engine/customer'
require 'sales_engine/invoice_item'
require 'sales_engine/invoice'
require 'sales_engine/item'
require 'sales_engine/merchant'
require 'sales_engine/transaction'
