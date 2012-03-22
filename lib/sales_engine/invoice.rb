require './lib/sales_engine/record'

class Invoice < Record
  attr_accessor :customer_id, :merchant_id, :status

  def initialize(attributes = {})
    super
    self.customer_id = attributes[:customer_id]
    self.merchant_id = attributes[:merchant_id]
    self.status = attributes[:status]
  end

  def self.random
    Database.instance.get_random_record("invoices")
  end

  def transactions
    Database.instance.find_all_by("transactions", "invoice_id", self.id)
  end

  def self.find_by_id(id)
    Database.instance.find_by("invoices", "id", id)
  end

  def self.find_by_customer_id(customer_id)
    Database.instance.find_by("invoices", "customer_id", customer_id)
  end
  
  def self.find_by_merchant_id(merchant_id)
    Database.instance.find_by("invoices", "merchant_id", merchant_id)
  end  

  def self.find_by_status(status)
    Database.instance.find_by("invoices", "status", status)
  end

  def self.find_by_created_at(time)
    Database.instance.find_by("invoices", "created_at", time)
  end

  def self.find_by_updated_at(time)
    Database.instance.find_by("invoices", "updated_at", time)
  end

  def self.find_all_by_id(id)
    Database.instance.find_all_by("invoices", "id", id)
  end

  def self.find_all_by_customer_id(customer_id)
    Database.instance.find_all_by("invoices", "customer_id", customer_id)
  end

  def self.find_all_by_merchant_id(merchant_id)
    Database.instance.find_all_by("invoices", "merchant_id", merchant_id)
  end

  def self.find_all_by_status(status)
    Database.instance.find_all_by("invoices", "status", status)
  end

  def self.find_all_by_created_at(time)
    Database.instance.find_all_by("invoices", "created_at", time)
  end

  def self.find_all_by_updated_at(time)
    Database.instance.find_all_by("invoices", "updated_at", time)
  end

end