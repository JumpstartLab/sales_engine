module SalesEngine
  class Merchant
    attr_accessor :id,
                  :name,
                  :created_at,
                  :updated_at,
                  :total_revenue,
                  :quantity

    def initialize(attributes={})
      self.id = attributes[:id].to_i
      self.name = attributes[:name]
      self.created_at = attributes[:created_at]
      self.updated_at = attributes[:updated_at]
      self.total_revenue = 0
      self.quantity = 0
    end

    def self.merchants
      merchants = DataStore.instance.merchants
    end

    def self.all
      self.merchants
    end

    def items_array
      items = DataStore.instance.items
    end

    def invoices_array
      invoices = DataStore.instance.invoices
    end

    def invoice_items_array
      invoice_items = DataStore.instance.invoice_items
    end

    def customers_array
      customers= DataStore.instance.customers
    end

    def transcations_array
      transactions = DataStore.instance.transactions
    end

    def self.random
        self.merchants.sample
        self.merchants.sample
    end

    def self.find_by_id(match)
      SalesEngine::Search.find_all_by("id", match, self.merchants).sample
    end

    def self.find_all_by_id(match)
      SalesEngine::Search.find_all_by("id", match, self.merchants)
    end

    def self.find_by_name(match)
      SalesEngine::Search.find_all_by("name", match, self.merchants).sample
    end

    def self.find_all_by_name(match)
      SalesEngine::Search.find_all_by("name", match, self.merchants)
    end

    def self.find_by_updated_at(match)
      SalesEngine::Search.find_all_by("updated_at", match, self.merchants).sample
    end

    def self.find_all_by_updated_at(match)
      SalesEngine::Search.find_all_by("updated_at", match, self.merchants)
    end

    def self.find_by_created_at(match)
      SalesEngine::Search.find_all_by("created_at", match, self.merchants).sample
    end

    def self.find_all_by_created_at(match)
      SalesEngine::Search.find_all_by("created_at", match, self.merchants)
    end

    def items
      items = []
      items = items_array.select { |item| item.merchant_id ==  id }
    end

    def invoices
      invoices = []
      invoices = invoices_array.select { |inv| inv.merchant_id == id}
    end

    def invoice_items
      merch_invoice_items =[]
      merch_invoice_item_ids = []
      invoices.each do |inv|
        merch_invoice_item_ids << inv.id
      end
      invoice_items_array.each do |inv_item|
        if merch_invoice_item_ids.include?(inv_item.invoice_id)
          merch_invoice_items << inv_item
        end
      end
      merch_invoice_items
    end

    def merch_quantity
      quantity = 0
      invoice_items.each do |inv_item|
        quantity += inv_item.quantity
      end
      quantity
    end

    def self.set_quantity
      self.merchants.each do |merchant|
        merchant.quantity = merchant.merch_quantity
      end
    end

    def merch_revenue
      revenue = 0
      invoice_items.each do |inv_item|
        revenue = revenue + inv_item.total
      end
      revenue
    end

    def merch_revenue_by_date(date)
      revenue = 0
      invoice_items.each do |inv_item|
        if date == inv_item.invoice.date
          revenue = revenue + inv_item.total
        end
      end
      revenue
    end

    # not working yet
    def revenue(*date)
      if date.nil?
        merch_revenue
      else
        merch_revenue_by_date(date)
      end
    end

    def self.set_revenue
      self.merchants.each do |merchant|
        merchant.total_revenue = merchant.merch_revenue
      end
    end

    def self.most_revenue(x)
      self.set_revenue
      sorted_merchants = self.merchants.sort_by { |merchant| merchant.total_revenue }.reverse
      sorted_merchants[0..x-1]
    end

    def self.most_items(x)
      self.set_quantity
      sorted_merchants = self.merchants.sort_by { |merchant| merchant.quantity }.reverse
      sorted_merchants[0..x-1]
    end

    def customer_ids
      merch_customer_ids =[]
      invoices.each do |invoice|
        merch_customer_ids << invoice.customer_id
      end
      merch_customer_ids
    end

    def favorite_customer
      customers_hash = {}
      customer_ids.each do |cust|
        if customers_hash.has_key?(cust)
          customers_hash[cust] += 1
        else
          customers_hash[cust] = 1
        end
      end
      fav_cust_id = customers_hash.max_by{ |cust, count| count}[0]
      Customer.find_by_id(fav_cust_id)
    end




    def customers_with_pending_invoices
      all_customers.select {|customer| customer.any_rejected == "yes"}
    end

    # def favorite_customer
    #   sorted_customers = all_customers.sort_by{ |customer| customer.transactions.length}.reverse
    #   sorted_customers.first
    # end

    def all_customers
      customers_array.select { |customer| customer_ids.include?(customer.id)}
    end

    # def invoice_ids
    #   invoice_ids = []
    #   invoices.each do |inv|
    #     invoice_ids << inv.id
    #   end
    #   invoice_ids
    # end

    # def transactions
    #   transcations_array.select {|trans| invoice_ids.include?(trans.invoice_id)}
    # end
    # def customer_invoice_ids
    #   invoices.select {|invoice| customer_ids.include?(invoice.customer_id)}
    # end

    # def customer_transactions
    #   transcations_array.select {|trans| customer_invoice_ids.include?(trans.invoice_id)}
    # end




  end
end