require 'logger'
module SalesEngine
  class Merchant < Record
    attr_accessor :name

    def initialize(attributes={})
      super
      self.name = attributes[:name]
    end

    def self.most_revenue(merchant_count)
      SalesEngine::Database.instance.merchants.sort_by { |merchant|
        merchant.revenue }.pop_multiple(merchant_count)
    end
    
    def self.most_items(merchant_count)
      sorted_list = SalesEngine::Database.instance.merchants.sort_by { |merchant|
        merchant.total_items_sold }.pop_multiple(merchant_count)
    end

    def self.revenue(date)
      revenue = BigDecimal.new("0")
      SalesEngine::Invoice.find_all_created_on(date).each { |invoice|
        revenue += invoice.total_revenue }
      revenue
    end

    def total_items_sold
      paid_invoices.collect { |invoice| invoice.total_items }.sum
    end

    def revenue(date=nil)
      user_date = date.nil? ? nil : date
      paid_invoices.collect do |invoice|
        if user_date.nil?
          invoice.total_revenue
        else
          invoice_date = Date.parse(Time.parse(invoice.created_at).strftime('%Y/%m/%d'))
          invoice_date == user_date ? invoice.total_revenue : 0
        end
      end.sum
    end

    def paid_invoices
      invoices.select { |invoice| invoice.paid? }
    end

    def favorite_customer
      customer_invoice_counter = { }
      self.invoices.each do |invoice|
        if customer_invoice_counter[invoice.customer]
          customer_invoice_counter[invoice.customer] += 1
        else
          customer_invoice_counter[invoice.customer] = 1
        end
      end
      customer_invoice_counter.sort_by {|customer| customer.last}.last.first
    end

    def customers_with_pending_invoices
      pending_invoices = invoices.select { |invoice| !invoice.paid? }
      pending_invoices.map { |invoice| invoice.customer }
    end

    def items
      SalesEngine::Database.instance.find_all_items_by_merchant_id(self.id)
    end

    def invoices
      SalesEngine::Database.instance.find_all_invoices_by_merchant_id(self.id)
    end

    def self.random
      SalesEngine::Database.instance.get_random_record("merchants")
    end

    def self.find_by_id(id)
      SalesEngine::Database.instance.find_by("merchants", "id", id)
    end

    def self.find_by_name(name)
      SalesEngine::Database.instance.find_by("merchants", "name", name)
    end

    def self.find_by_created_at(time)
      SalesEngine::Database.instance.find_by("merchants", "created_at", time)
    end

    def self.find_by_updated_at(time)
      SalesEngine::Database.instance.find_by("merchants", "updated_at", time)
    end

    def self.find_all_by_id(id)
      SalesEngine::Database.instance.find_all_by("merchants", "id", id)
    end

    def self.find_all_by_name(name)
      SalesEngine::Database.instance.find_all_by("merchants", "name", name)
    end

    def self.find_all_by_created_at(time)
      SalesEngine::Database.instance.find_all_by("merchants", "created_at", time)
    end

    def self.find_all_by_updated_at(time)
      SalesEngine::Database.instance.find_all_by("merchants", "updated_at", time)
    end
  end
end