require './data_loader'
require './data_store'

class Customer
  attr_accessor :cust_id,
                :first_name,
                :last_name,
                :create_date,
                :update_date

  def initialize(customer)
    self.cust_id = customer[:id].to_s
    self.first_name = customer[:first_name].to_s
    self.last_name = customer[:last_name].to_s
    self.create_date = customer[:created_at].to_s
    self.update_date = customer[:updated_at].to_s
  end

  def self.customers=(value)
    @@customers = value
  end

  def self.customers
    self.customers = []
    ObjectSpace.each_object(Customer) {|o| @@customers<<o}
    @@customers
  end

  def self.random
    random = rand(self.customers.count)
    @@customers[random]
  end

  def self.find_by_cust_id(match)
    found = []
    found = self.customers.each do |customer|
      if customer.cust_id == match
        found <<customer
      end
    end
    found[rand(found.count)]
  end

  def self.find_all_by_cust_id(match)
    found = []
    found = self.customers.each do |customer|
      if customer.cust_id == match
        found <<customer
      end
    end
    found
  end

  def self.find_by_first_name(match)
    found = []
    found = self.customers.each do |customer|
      if customer.first_name == match
        found <<customer
      end
    end
    found[rand(found.count)]
  end

  def self.find_all_by_first_name(match)
    found = []
    found = self.customers.each do |customer|
      if customer.first_name == match
        found <<customer
      end
    end
    found
  end

  def self.find_by_last_name(match)
    found = []
    found = self.customers.each do |customer|
      if customer.last_name == match
        found <<customer
      end
    end
    found[rand(found.count)]
  end

  def self.find_all_by_last_name(match)
    found = []
    found = self.customers.each do |customer|
      if customer.last_name == match
        found <<customer
      end
    end
    found
  end

  def self.find_by_create_date(match)
    found = []
    found = self.customers.each do |customer|
      if customer.create_date == match
        found <<customer
      end
    end
    found[rand(found.count)]
  end

  def self.find_all_by_create_date(match)
    found = []
    found = self.customers.each do |customer|
      if customer.create_date == match
        found <<customer
      end
    end
    found
  end

  def self.find_by_update_date(match)
    found = []
    found = self.customers.each do |customer|
      if customer.update_date == match
        found <<customer
      end
    end
    found[rand(found.count)]
  end

  def self.find_all_by_update_date(match)
    found = []
    found = self.customers.each do |customer|
      if customer.update_date == match
        found <<customer
      end
    end
    found
  end


end

