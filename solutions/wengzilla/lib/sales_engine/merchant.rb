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

    def initialize(attrs)
      self.id = Cleaner::fetch_id("merchant", attrs[:id])
      self.name = attrs[:name]
      self.created_at = Cleaner::fetch_date(attrs[:created_at])
      self.updated_at = Cleaner::fetch_date(attrs[:updated_at])

      SalesEngine::Database.instance.merchant_list << self
      SalesEngine::Database.instance.merchant_id_hash[ self.id ] = self
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
      date = SalesEngine::Merchant.clean_date(date)
      invoices.select {|inv| inv.updated_at == date}
    end

    def invoices_on_range(range)
      invoices.select do |inv|
        inv.created_at <= range.last && inv.created_at >= range.first
      end
    end

    def revenue(*date)
      date = date.first
      if date.is_a?(Range)
        results = invoices_on_range(date)
      elsif date
        results = invoices_on_date(date)
      else results = invoices
      end
      results.inject(0) { |init, inv| init + inv.invoice_revenue }
    end

    def paid_invoices
      invoices.select { |inv| inv if inv.is_successful? }
    end

    def paid_invoices_by_customer
      customer_data = { }
      paid_invoices.each do |invoice|
        customer_data[ invoice.customer_id ] ||= 0
        customer_data[ invoice.customer_id ] += 1
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
      if date.is_a? Range
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
        created_at = Date.parse(i.created_at.to_s)
        if range.first <= created_at && range.last >= created_at
            total_revenue += i.invoice_revenue
        end
      end
      total_revenue
    end

    def self.clean_date(date)
      date = Date.parse(date.to_s) if date.kind_of? String
      date
    end

    def self.merchants_by_revenue
      data = { }
      SalesEngine::Invoice.successful_invoices.each do |i|
        data[ i.merchant_id ] ||= 0
        data[ i.merchant_id ] += i.invoice_revenue
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
        item_data[ invoice_item.merchant_id ] ||= 0
        item_data[ invoice_item.merchant_id ] += invoice_item.quantity
      end
      item_data
    end

    def self.revenue_on_dates
      date_data = { }
      SalesEngine::Invoice.successful_invoices.each do |i|
        date_data[ i.created_at.strftime("%Y/%m/%d") ]||= 0
        date_data[ i.created_at.strftime("%Y/%m/%d") ]+= i.invoice_revenue.to_i
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