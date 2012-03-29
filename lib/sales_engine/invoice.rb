module SalesEngine
  require 'sales_engine/dynamic_finder'
  class Invoice
    INVOICE_ATTS = [
      # "id",
      "customer_id",
      "merchant_id",
      "status",
      "created_at",
      "updated_at"
    ]

    attr_accessor :id, :customer_id, :merchant_id, :status,
                  :created_at, :updated_at, :result, :revenue

    def initialize(attributes)
      if attributes[:id]
        self.id = attributes[:id].to_i
      else
        self.id = ( SalesEngine::Database.instance.invoice_list.size + 1 ).to_i
      end
      self.customer_id = attributes[:customer_id].to_i
      self.merchant_id = attributes[:merchant_id].to_i
      self.status = attributes[:status]
      if attributes[:created_at]
        self.created_at = Date.parse(attributes[:created_at])
      else
        self.created_at = Date.today
      end
      if attributes[:updated_at]
        self.updated_at = Date.parse(attributes[:updated_at])
      else
        self.updated_at = Date.today
      end

      SalesEngine::Database.instance.invoice_list << self
      SalesEngine::Database.instance.invoice_id_hash[ self.id ] = self
    end

    def self.attributes_for_finders
      INVOICE_ATTS
    end

    extend SalesEngine::DynamicFinder

    def transactions
      SalesEngine::Transaction.find_all_by_invoice_id(self.id)
    end

    def invoice_items
      SalesEngine::InvoiceItem.find_all_by_invoice_id(self.id)
    end

    def invoice_revenue
      return 0 unless self.is_successful?
      return self.revenue if self.revenue

      t_rev = SalesEngine::InvoiceItem.total_revenue_by_invoice_id(self.id)
      self.revenue = t_rev
    end

    def self.create(attributes)
      invoice = self.new( :customer_id => attributes[:customer].id,
                          :merchant_id => attributes[:merchant].id,
                          :status => attributes[:status])

      attributes[:items].each do |item|
        SalesEngine::InvoiceItem.create( { :invoice_id => invoice.id,
                                           :item => item } )
      end
      invoice
    end

    def customer
      SalesEngine::Customer.find_by_id(self.customer_id)
    end

    def items
      items = self.invoice_items.collect do |i_i|
        SalesEngine::Item.find_by_id(i_i.item_id)
      end
    end

    def is_successful?(*refresh)
      return self.result unless self.result.nil? || refresh.first

      transactions = SalesEngine::Transaction.find_all_by_invoice_id(self.id)
      self.result = transactions.any? do |transaction|
        transaction.is_successful?
      end
    end

    def self.successful_invoices
      SalesEngine::Database.instance.invoice_list.select do |inv|
        inv.is_successful?
      end
    end

    def self.pending
      SalesEngine::Database.instance.invoice_list - successful_invoices
    end

    def self.find_all_successful_invoices_by_date(date)
      successful_invoices.select do |i|
        dt = i.updated_at
        date = Time.parse(date) if date.kind_of? String
        i if date == Time.new(dt.year, dt.mon, dt.mday)
      end
    end

    def charge(attrs)
      SalesEngine::Transaction.create({:invoice_id => self.id,
        :credit_card_number => attrs[:credit_card_number],
        :credit_card_expiration => attrs[:credit_card_expiration],
        :result => attrs[:result] })
    end

    def self.clean_date(date)
      date = Date.parse(date.to_s)
    end

    def self.invoices_on_date(date)
      date = clean_date(date)
      successful_invoices.select { |inv| clean_date( inv.created_at ) == date }
    end

    # def self.invoices_on_range(range)
    #   successful_invoices.select do |inv|
    #     # DOES NOT HANDLE EDGE CASE WELL... e.g. RANGE DATE IS SAME
    #     # AS UPDATED DATE
    #     inv.created_at <= range.last && inv.created_at >= range.first
    #   end
    # end

    def self.total_revenue_over_period(date)
      if date
        revenue_invoices_on_date(Date.parse(date.to_s))
      else
        revenue_invoices_on_all
      end
    end

    # def self.revenue_invoices_on_range(date)
    #   inv_results = invoices_on_range(date)
    #   tr = inv_results.inject(0) { |init, inv| init + inv.invoice_revenue }
    #   return tr, inv_results.size
    # end

    def self.revenue_invoices_on_date(date)
      inv_results = invoices_on_date(date)
      tr = inv_results.inject(0) { |init, inv| init + inv.invoice_revenue }
      return tr, inv_results.size
    end

    def self.revenue_invoices_on_all
      inv_results = successful_invoices
      tr = inv_results.inject(0) { |init, inv| init + inv.invoice_revenue }
      return tr, inv_results.size
    end

    def self.total_items_over_period(date)
      if date
        items_on_date(Date.parse(date.to_s))
      else
        items_on_all
      end
    end

    def self.items_on_date(date)
      items = 0
      inv_results = invoices_on_date(date)
      inv_results.each do |inv|
        inv.invoice_items.each do |inv_items|
          items += inv_items.quantity
        end
      end
      return items, inv_results.size
    end

    def self.items_on_all
      items = 0
      inv_results = successful_invoices
      inv_results.each do |inv|
        inv.invoice_items.each do |inv_items|
          items += inv_items.quantity
        end
      end
      return items, inv_results.size
    end

    def self.average_revenue(*date)
      date = date.first
      total_revenue, invoice_count = total_revenue_over_period(date)
      # puts total_revenue.inspect
      # puts invoice_count.inspect
      total_revenue / invoice_count # average revenue
    end

    def self.average_items(*date)
      date = date.first
      total_items, invoice_count = total_items_over_period(date)
      (BigDecimal.new(total_items.to_s) / invoice_count).round(2)
    end


      # invoices = SalesEngine::Database.instance.invoice_list
      # puts SalesEngine::InvoiceItem.total_revenue.inspect
      # avg_rev = SalesEngine::InvoiceItem.total_revenue / invoices.size

      # avg_rev = avg_rev.to_f.round(2)

      #   #collect all the invoice ids that happened on date
      #     #call Invoice Item's find total_rev_by_att on each invoice id
      #     #sum all of them
      #     #divide the sum by all the invoices that happened on date
      #   total_rev = BigDecimal.new("0.00")
      #   date = Time.parse(date.first)
      #   inv_on_date = find_all_successful_invoices_by_date(date)
      #   inv_ids_on_date = inv_on_date.collect { |inv| inv.id }
      #   inv_ids_on_date.each do |inv_id|
      #     rev = SalesEngine::InvoiceItem.total_revenue_by_invoice_id(inv_id)
      #     total_rev += rev
    #     # end

    #     return 0 if inv_on_date.empty?
    #     avg_rev = total_rev / inv_on_date.size
    #     SalesEngine::InvoiceItem.total_revenue(date) / find_all_by_date(date)

    # end

  end
end

