module SalesEngine
  class Invoice < Record
    attr_accessor :customer_id, :merchant_id, :status

    def initialize(attributes = {})
      super
      self.customer_id = attributes[:customer_id]
      self.merchant_id = attributes[:merchant_id]
      self.status = attributes[:status]
    end

    def total_revenue
      revenue = BigDecimal.new("0")
      all_transactions_failed = true
      SalesEngine::Database.instance.find_all_by("transactions", "invoice_id", self.id).each { |trans|
        if !trans.result.downcase.include?("fail")
          all_transactions_failed = false
          break
        end}
      if !all_transactions_failed
        SalesEngine::Database.instance.find_all_by("invoiceitems", "invoice_id", self.id).each { |item|
          revenue = revenue + (item.unit_price * item.quantity) }
      end
      revenue
    end

    def self.create(attributes)
      invoice = SalesEngine::Invoice.new(:id => SalesEngine::Database.instance.invoices.count + 1, :customer_id => attributes[:customer_id].id,
        :merchant_id => attributes[:merchant_id].id, :status => attributes[:status])
      attributes[:items].each do |item|
        invoice_item = SalesEngine::InvoiceItem.new(:id => SalesEngine::Database.instance.invoiceitems.count + 1,
          :invoice_id => invoice.id, :item_id => item.id, :quantity => 1)
        SalesEngine::Database.instance.add_to_list(invoice_item)
      end
      attributes[:transaction].invoice_id = invoice.id
      SalesEngine::Database.instance.add_to_list(invoice)
      invoice
    end

    def charge(attributes)
      transaction = SalesEngine::Transaction.new(:id => SalesEngine::Database.instance.transactions.count + 1,
        :invoice_id => self.id, :credit_card_number => attributes[:credit_card_number],
        :credit_card_expiration_date => attributes[:credit_card_expiration_date], :result => attributes[:result])
      SalesEngine::Database.instance.add_to_list(transaction)
      transaction
    end

    def total_items
      SalesEngine::Database.instance.find_all_by("invoiceitems", "invoice_id", self.id).count
    end

    def self.random
      SalesEngine::Database.instance.get_random_record("invoices")
    end

    def transactions
      SalesEngine::Database.instance.find_all_by("transactions", "invoice_id", self.id)
    end

    def invoice_items
      SalesEngine::Database.instance.find_all_by("invoiceitems", "invoice_id", self.id)
    end

    def items
      items = []
      invoice_items = SalesEngine::Database.instance.find_all_by("invoiceitems", "invoice_id", self.id)
      items = invoice_items.collect { |invoice_item|
        SalesEngine::Database.instance.find_by("items", "id", invoice_item.item_id) }
    end

    def customer
      SalesEngine::Database.instance.find_by("customers", "id", self.customer_id)
    end

    def merchant
      SalesEngine::Database.instance.find_by("merchants", "id", self.merchant_id)
    end

    def self.find_by_id(id)
      SalesEngine::Database.instance.find_by("invoices", "id", id)
    end

    def self.find_by_customer_id(customer_id)
      SalesEngine::Database.instance.find_by("invoices", "customer_id", customer_id)
    end

    def self.find_by_merchant_id(merchant_id)
      SalesEngine::Database.instance.find_by("invoices", "merchant_id", merchant_id)
    end

    def self.find_by_status(status)
      SalesEngine::Database.instance.find_by("invoices", "status", status)
    end

    def self.find_by_created_at(time)
      SalesEngine::Database.instance.find_by("invoices", "created_at", time)
    end

    def self.find_by_updated_at(time)
      SalesEngine::Database.instance.find_by("invoices", "updated_at", time)
    end

    def self.find_all_by_id(id)
      SalesEngine::Database.instance.find_all_by("invoices", "id", id)
    end

    def self.find_all_by_customer_id(customer_id)
      SalesEngine::Database.instance.find_all_by("invoices", "customer_id", customer_id)
    end

    def self.find_all_by_merchant_id(merchant_id)
      SalesEngine::Database.instance.find_all_by("invoices", "merchant_id", merchant_id)
    end

    def self.find_all_by_status(status)
      SalesEngine::Database.instance.find_all_by("invoices", "status", status)
    end

    def self.find_all_by_created_at(time)
      SalesEngine::Database.instance.find_all_by("invoices", "created_at", time)
    end

    def self.find_all_by_updated_at(time)
      SalesEngine::Database.instance.find_all_by("invoices", "updated_at", time)
    end

    def self.find_all_created_on(date)
      SalesEngine::Database.instance.find_all_created_on("invoices", date)
    end
  end
end