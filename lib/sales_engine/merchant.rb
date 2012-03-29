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
      merchants     = DataStore.instance.merchants
    end

    def items_array
      items         = DataStore.instance.items
    end

    def invoices_array
      invoices      = DataStore.instance.invoices
    end

    def i_items_array
      invoice_items = DataStore.instance.invoice_items
    end

    def customers_array
      customers     = DataStore.instance.customers
    end

    def transcations_array
      transactions  = DataStore.instance.transactions
    end

    def self.random
        self.merchants.sample
    end

    def self.method_missing(method_name, *args, &block)
      if method_name =~ /^find_by_(\w+)$/
        Search.find_by_attribute($1, args.first, self.merchants)
      elsif method_name =~ /^find_all_by_(\w+)$/
        Search.find_all_by_attribute($1, args.first, self.merchants)
      else
        super
      end
    end

    def items
      items_array.select { |item| item.merchant_id ==  id }
    end

    def invoices
      invoices_array.select { |inv| inv.merchant_id == id}
    end

    def successful_invoices
      invoices.select { |invoice| invoice.successful? }
    end

    def invoice_items
      merch_i_item_ids = invoices.collect { |inv| inv.id}
      i_items_array.select { |i_i| merch_i_item_ids.include?(i_i.invoice_id)}
    end

    def successful_invoice_items
      merch_i_item_ids = successful_invoices.collect { |inv| inv.id}
      i_items_array.select { |i_i| merch_i_item_ids.include?(i_i.invoice_id)}
    end

    def merch_quantity
      quantity = 0
      successful_invoice_items.each do |inv_item|
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
      successful_invoice_items.each do |inv_item|
        revenue = revenue + inv_item.total
      end
      revenue = (revenue/100.0).to_s
      revenue = BigDecimal.new(revenue)
    end

    def revenue(*date)
      if date ==[]
        merch_revenue
      else
        merch_revenue_by_date(*date)
      end
    end

    def merch_revenue_by_date(date)
      rev = 0
      successful_invoice_items.each do |inv_item|
        if date == inv_item.invoice.date
          rev = rev + inv_item.total
        end
      end
      BigDecimal.new((rev/100.0).to_s)
    end

    def self.set_revenue
      self.merchants.each do |merchant|
        merchant.total_revenue = merchant.merch_revenue
      end
    end

    def self.most_revenue(x)
      self.set_revenue
      sorted_merchants = self.merchants.sort_by { |merch| merch.total_revenue }
      sorted_merchants.reverse[0..x-1]
    end

    def self.most_items(x)
      self.set_quantity
      sorted_merchants = self.merchants.sort_by { |merch| merch.quantity }
      sorted_merchants.reverse[0..x-1]
    end

    def customer_ids
      merch_customer_ids =[]
      invoices.each do |invoice|
        if invoice.successful?
          merch_customer_ids << invoice.customer_id
        end
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
      pending_invoices = invoices.select { |inv| !inv.successful? }
      pending_invoices.collect {|inv| Customer.find_by_id(inv.customer_id)}
    end

    def all_customers
      customers_array.select { |customer| customer_ids.include?(customer.id)}
    end

    def self.revenue(date)
      date_revs = {}
      self.merchants.each do |merchant|
        merchant.successful_invoices.each do |invoice|
          if date_revs.has_key?(invoice.created_at)
            date_revs[invoice.created_at] += invoice.revenue
          else
            date_revs[invoice.created_at] = invoice.revenue
          end
        end
      end
      BigDecimal.new(date_revs[date].to_s)/100
    end
  end
end