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
      puts date.inspect
      puts date.class
      date = SalesEngine::Merchant.clean_date(date)
      invoices.select {|inv| inv.updated_at == date}
    end

    def invoices_on_range(range)
      invoices.select do |inv|
        # DOES NOT HANDLE EDGE CASE WELL... e.g. RANGE DATE IS SAME
        # AS UPDATED DATE
        inv.updated_at <= range.last && inv.updated_at >= range.first
      end
    end

    def revenue(*date)
      if date.first.is_a?(Range)
        results = invoices_on_range(date)
      elsif date.first
        results = invoices_on_date(date.first)
      else results = invoices
      end
      total_revenue = BigDecimal.new("0.00")
      results.each { |i| total_revenue += i.invoice_revenue }
      total_revenue
    end

    def paid_invoices
      invoices.select { |inv| inv if inv.is_successful? }
    end

    def paid_invoices_by_customer
      customer_data = { }
      paid_invoices.each do |invoice|
        customer_data[ invoice.customer_id.to_s.to_sym ] ||= 0
        customer_data[ invoice.customer_id.to_s.to_sym ] += 1
      end
      customer_data
    end

    def favorite_customer
      return nil if paid_invoices_by_customer.empty?
      customer_data_max = paid_invoices_by_customer.max_by{ |k, v| v }
      SalesEngine::Customer.find_by_id(customer_data_max.first)
    end

    def pending_invoices
      invoices - paid_invoices
    end

    def customers_with_pending_invoices
      pending_invoices.collect do |inv|
        SalesEngine::Customer.find_by_id(inv.customer_id)
      end
    end

    def self.revenue(date)
      if date.is_a?(Range)
        total_revenue_on_range(date)
      else
        total_revenue_on_date(date)
      end
    end

    def self.total_revenue_on_date(date)
      total_revenue = BigDecimal.new("0.00")
      SalesEngine::Invoice.successful_invoices.each do |i|
        if clean_date(date) == i.updated_at
          total_revenue += i.invoice_revenue
        end
      end
      total_revenue
    end

    def self.total_revenue_on_range(range)
      total_revenue = 0
      SalesEngine::Invoice.successful_invoices.each do |i|
        updated_at = Date.parse(i.updated_at.to_s)
        if range.first <= updated_at && range.last >= updated_at
            total_revenue += i.invoice_revenue
        end
      end
      total_revenue
    end

    def self.clean_date(date)
      date = Date.parse(date) if date.kind_of? String
      date
    end

    def self.merchants_by_revenue
      data = { }
      SalesEngine::Invoice.successful_invoices.each do |i|
        merchant_id = i.merchant_id.to_sym
        data[ merchant_id ] ||= 0
        data[ merchant_id ] += i.invoice_revenue
      end
      data
    end

    def self.most_revenue(num)
      data = merchants_by_revenue
      return nil if data.empty?
      data = data.sort_by{ |merchant_id, revenue| -revenue }[0..(num-1)]
      data.collect { |merchant_id, revenue| self.find_by_id(merchant_id) }
    end

    def self.paid_invoice_items
      SalesEngine::InvoiceItem.successful_invoice_items
    end

    def self.merchants_by_items_sold
      item_data = { }

      paid_invoice_items.each do |invoice_item|
        item_data[ invoice_item.merchant_id.to_sym ] ||= 0
        item_data[ invoice_item.merchant_id.to_sym ] += invoice_item.quantity
      end
      item_data
    end

    def self.revenue_on_dates
      date_data = { }
      SalesEngine::Invoice.successful_invoices.each do |i|
        date_data[ i.updated_at.strftime("%Y/%m/%d") ]||= 0
        date_data[ i.updated_at.strftime("%Y/%m/%d") ]+= i.invoice_revenue.to_i
      end
      date_data
    end

    def self.dates_by_revenue(*num)
      date_data = revenue_on_dates.sort_by { |date, rev| -rev }
      date_data = date_data[ 0..(num.first-1) ] unless num.empty?
      date_data.collect { |date, rev| Date.parse(date) }
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