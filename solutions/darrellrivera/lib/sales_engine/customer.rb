module SalesEngine
  class Customer < Record
    attr_accessor :first_name, :last_name

    def initialize(attributes={})
      super
      self.first_name = attributes[:first_name]
      self.last_name = attributes[:last_name]
    end

    def transactions
      customer_transactions = []
      invoices.each {|invoice|
        invoice.transactions.each {|transaction|
          customer_transactions << transaction } }
      customer_transactions.sort_by {|transaction| transaction.id}
    end

    def favorite_merchant
      merchant_invoice_counter = { }
      invoices.each do |invoice|
        if merchant_invoice_counter[invoice.merchant]
          merchant_invoice_counter[invoice.merchant] += 1
        else
          merchant_invoice_counter[invoice.merchant] = 1
        end
      end
      merchant_invoice_counter.sort_by {|merchant| merchant.last}.last.first
    end

    def invoices
      DATABASE.find_all_by("invoices", "customer_id", self.id)
    end

    def self.random
      DATABASE.get_random_record("customers")
    end

    def self.find_by_id(id)
      DATABASE.find_by("customers", "id", id)
    end

    def self.find_by_first_name(first_name)
      DATABASE.find_by("customers", "first_name", first_name)
    end

    def self.find_by_last_name(last_name)
      DATABASE.find_by("customers", "last_name", last_name)
    end

    def self.find_by_created_at(time)
      DATABASE.find_by("customers", "created_at", time)
    end

    def self.find_by_updated_at(time)
      DATABASE.find_by("customers", "updated_at", time)
    end

    def self.find_all_by_id(id)
      DATABASE.find_all_by("customers", "id", id)
    end

    def self.find_all_by_first_name(first_name)
      DATABASE.find_all_by("customers", "first_name", first_name)
    end

    def self.find_all_by_last_name(last_name)
      DATABASE.find_all_by("customers", "last_name", last_name)
    end

    def self.find_all_by_created_at(time)
      DATABASE.find_all_by("customers", "created_at", time)
    end

    def self.find_all_by_updated_at(time)
      DATABASE.find_all_by("customers", "updated_at", time)
    end
  end
end