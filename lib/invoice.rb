require './data_store'
require './search'

class Invoice
  extend Search
  attr_accessor :id,
                :customer_id,
                :merchant_id,
                :status,
                :created_at,
                :updated_at

  def initialize(attributes={})
    self.id = attributes[:id].to_s
    self.customer_id = attributes[:customer_id].to_s
    self.merchant_id = attributes[:merchant_id].to_s
    self.status = attributes[:status].to_s
    self.created_at = attributes[:created_at].to_s
    self.updated_at = attributes[:updated_at].to_s
  end

  def self.invoices
    invoices = []
    ObjectSpace.each_object(Invoice) {|o| invoices<<o}
    invoices
  end

  def self.random
      self.invoices.sample
      puts self.invoices.sample
  end

  def self.find_by_id(match)
    puts Search.find_all_by("id", match, self.invoices).sample.inspect
  end

  def self.find_all_by_id(match)
    puts Search.find_all_by("id", match, self.invoices).inspect
  end

  def self.find_by_customer_id(match)
    puts Search.find_all_by("customer_id", match, self.invoices).sample.inspect
  end

  def self.find_all_by_customer_id(match)
    puts Search.find_all_by("customer_id", match, self.invoices).inspect
  end

  def self.find_by_merchant_id(match)
    puts Search.find_all_by("merchant_id", match, self.invoices).sample.inspect
  end

  def self.find_all_by_merchant_id(match)
    puts Search.find_all_by("merchant_id", match, self.invoices).inspect
  end

  def self.find_by_status(match)
    puts Search.find_all_by("status", match, self.invoices).sample.inspect
  end

  def self.find_all_by_status(match)
    puts Search.find_all_by("status", match, self.invoices).inspect
  end

  def self.find_by_updated_at(match)
    puts Search.find_all_by("updated_at", match, self.invoices).sample.inspect
  end

  def self.find_all_by_updated_at(match)
    puts Search.find_all_by("updated_at", match, self.invoices).inspect
  end

  def self.find_by_created_at(match)
    puts Search.find_all_by("created_at", match, self.invoices).sample.inspect
  end

  def self.find_all_by_created_at(match)
    puts Search.find_all_by("created_at", match, self.invoices).inspect
  end

end