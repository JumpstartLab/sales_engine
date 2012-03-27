module SalesEngine
  require 'sales_engine/dynamic_finder'
  class Merchant
    attr_accessor :id, :name, :created_at, :updated_at

    MERCHANT_ATTS = [
      "id",
      "name",
      "created_at",
      "updated_at"
    ]

    def initialize(attributes)
      self.id = attributes[:id]
      self.name = attributes[:name]
      self.created_at = attributes[:created_at]
      self.updated_at = attributes[:updated_at]
    end

    def self.attributes_for_finders
      MERCHANT_ATTS
    end

    extend SalesEngine::DynamicFinder

    def items
      SalesEngine::Item.find_all_by_merchant_id(self.id)
    end

    def invoices
      SalesEngine::Invoice.find_all_by_merchant_id(self.id)
    end

    def invoices_on_date(date)
      date = Time.parse(date)
      invoices.select {|inv| inv if inv.updated_at == date}
    end

    def revenue(*date)
      total_revenue = BigDecimal.new("0.00")
      date.empty? ? results = invoices : results = invoices_on_date(date.first)
      results.each { |i| total_revenue += i.invoice_revenue }
      total_revenue
    end

    def successful_invoices
      results = invoices.select { |inv| inv if inv.is_successful? }
    end

    def favorite_customer
      customer_data = { }
      successful_invoices.each do |invoice|
        customer_data[ invoice.customer_id.to_sym ] ||= 0
        customer_data[ invoice.customer_id.to_sym ] += 1
      end
      return nil if customer_data.empty?
      customer_data_max = customer_data.max_by{ |k, v| v }
      SalesEngine::Customer.find_by_id(customer_data_max.first)   
    end

    def customers_with_pending_invoices  
      pending_invoices = invoices - successful_invoices
      pending_invoices.collect do |inv|
        SalesEngine::Customer.find_by_id(inv.customer_id)
      end
    end

    def self.revenue(date)
      total_revenue = BigDecimal.new("0.00")
      SalesEngine::Invoice.successful_invoices.each do |i|
        dt = i.updated_at
        if clean_date(date) == Time.new(dt.year, dt.mon, dt.mday)
          total_revenue += i.invoice_revenue
        end
      end
      total_revenue
    end

    def self.clean_date(date)
      date = Time.parse(date) if date.kind_of? String
      date
    end

    def self.merchants_by_revenue
      data = { }
      SalesEngine::Invoice.successful_invoices.each do |i|
        data[ i.merchant_id.to_sym ] ||= 0
        data[ i.merchant_id.to_sym ] += i.invoice_revenue
      end
      data
    end

    def self.most_revenue(num)
      data = merchants_by_revenue
      return nil if data.empty?
      data = data.sort_by{ |k, v| -v }[0..(num-1)]
      data.collect { |merchant_id, revenue| self.find_by_id(merchant_id) }
    end

    def self.merchants_by_items_sold
      successful_invoice_items = SalesEngine::InvoiceItem.successful_invoice_items
      item_data = { }

      successful_invoice_items.each do |invoice_item|
        item_data[ invoice_item.merchant_id.to_sym ] ||= 0
        item_data[ invoice_item.merchant_id.to_sym ] += invoice_item.quantity 
      end
      item_data
    end

    def self.revenue_on_dates
      date_data = { }
      SalesEngine::Invoice.successful_invoices.each do |i|
        date_data[ i.updated_at.to_sym ] ||= 0
        date_data[ i.updated_at.to_sym ] += i.invoice_revenue
      end
      date_data.sort_by { |date, revenue| -revenue }
    end

    def self.dates_by_revenue(*num)
      x = revenue_on_dates.sort_by { |date, revenue| -revenue }
      num.empty? ? x : x[0..(num.first-1)]
    end

    def self.most_items(num)
      item_data = merchants_by_items_sold.sort_by do |merchant_id, quantity| 
        -quantity
      end

      item_data[0..(num-1)].collect do |merchant_id, quantity|
        self.find_by_id(merchant_id)
      end
    end

  end
end