module SalesEngine
  class Invoice
    INVOICE_ATTS = [
      "id",
      "customer_id",
      "merchant_id",
      "status",
      "created_at",
      "updated_at"
    ]

    attr_accessor :id, :customer_id, :merchant_id, :status,
                  :created_at, :updated_at, :result, :revenue

    def initialize(attrs)
      self.id = Cleaner::fetch_id("invoice", attrs[:id])
      self.customer_id = attrs[:customer_id].to_i
      self.merchant_id = attrs[:merchant_id].to_i
      self.status = attrs[:status]
      self.created_at = Cleaner::fetch_date(attrs[:created_at])
      self.updated_at = Cleaner::fetch_date(attrs[:updated_at])

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

    #Creates a new invoice and then creates all the invoice items
    #that go with it.
    def self.create(attributes)
      new_invoice = self.new( :customer_id => attributes[:customer].id,
                              :merchant_id => attributes[:merchant].id,
                              :status => attributes[:status])

      attributes[:items].each do |item|
        SalesEngine::InvoiceItem.create( { :invoice_id => new_invoice.id,
                                           :item => item } )
      end
      new_invoice
    end

    def charge(attrs)
      SalesEngine::Transaction.create({:invoice_id => self.id,
        :credit_card_number => attrs[:credit_card_number],
        :credit_card_expiration => attrs[:credit_card_expiration],
        :result => attrs[:result] })
    end

    def self.successful_invoices
      SalesEngine::Database.instance.invoice_list.select do |inv|
        inv.is_successful?
      end
    end

    def self.pending
      SalesEngine::Database.instance.invoice_list - successful_invoices
    end

    def self.clean_date(date)
      date = Date.parse(date.to_s)
    end

    def self.invoices_on_date(date)
      date = clean_date(date)
      successful_invoices.select { |inv| clean_date( inv.created_at ) == date }
    end

    def self.total_revenue_over_period(date)
      if date
        revenue_invoices_on_date(Date.parse(date.to_s))
      else
        revenue_invoices_on_all
      end
    end

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

    def self.total_items_over_period(*date)
      if date.any?
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
      successful_invoices.each do |inv|
        inv.invoice_items.each do |inv_item|
          items += inv_item.quantity
        end
      end
      return items, successful_invoices.size
    end

    def self.average_revenue(*date)
      date = date.first
      total_revenue, invoice_count = total_revenue_over_period(date)
      (total_revenue / invoice_count).round(2) # average revenue
    end

    def self.average_items(*date)
      date = date.first
      total_items, invoice_count = total_items_over_period(date)
      (BigDecimal.new(total_items.to_s) / invoice_count).round(2)
    end
  end
end

