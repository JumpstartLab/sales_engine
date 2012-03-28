module SalesEngine
  class Invoice < Record
    attr_accessor :customer_id, :merchant_id, :status

    def initialize(attributes = {})
      super
      self.customer_id = attributes[:customer_id].to_i
      self.merchant_id = attributes[:merchant_id].to_i
      self.status = attributes[:status]
    end

    def paid?
      transactions.any? { |transaction| transaction.successful? }
    end

    def total_revenue
      revenue = BigDecimal.new("0")
      all_transactions_failed = true
      DATABASE.find_all_by("transactions", "invoice_id", id).each { |trans|
        if !trans.result.downcase.include?("fail")
          all_transactions_failed = false
          break
        end}
      if !all_transactions_failed
        DATABASE.find_all_by("invoiceitems", "invoice_id", id).each { |item|
          revenue = revenue + (item.unit_price * item.quantity) }
      end
      revenue
    end

    def self.create(values)
      invoice = SalesEngine::Invoice.new(:id => DATABASE.invoices.count + 1,
        :customer_id => values[:customer].id,
        :merchant_id => values[:merchant].id,
        :status => values[:status])
      create_invoice_items(values[:items], invoice)
      values[:transaction].invoice_id = invoice.id unless !values[:transaction]
      DATABASE.add_to_list(invoice)
      invoice
    end

    def self.create_invoice_items(items, invoice)
      items.each do |item|
        invoice_item = SalesEngine::InvoiceItem.new(:id =>
          DATABASE.invoiceitems.count + 1, :invoice_id => invoice.id,
          :item_id => item.id, :quantity => 1)
        DATABASE.add_to_list(invoice_item)
      end
    end

    def charge(values)
      transaction = SalesEngine::Transaction.new(:id =>
        DATABASE.transactions.count + 1, :invoice_id => self.id,
        :credit_card_number => values[:credit_card_number],
        :credit_card_expiration_date => values[:credit_card_expiration_date],
        :result => values[:result])
      DATABASE.add_to_list(transaction)
      transaction
    end

    def total_items
      DATABASE.find_all_by("invoiceitems", "invoice_id", id).count
    end

    def self.random
      DATABASE.get_random_record("invoices")
    end

    def transactions
      DATABASE.find_all_by("transactions", "invoice_id", id)
    end

    def invoice_items
      DATABASE.find_all_by("invoiceitems", "invoice_id", id)
    end

    def items
      items = []
      invoice_items = DATABASE.find_all_by("invoiceitems", "invoice_id", id)
      items = invoice_items.collect { |invoice_item|
        DATABASE.find_by("items", "id", invoice_item.item_id) }
    end

    def customer
      DATABASE.find_by("customers", "id", customer_id)
    end

    def merchant
      DATABASE.find_by("merchants", "id", merchant_id)
    end

    def self.find_by_id(id)
      DATABASE.find_by("invoices", "id", id)
    end

    def self.find_by_customer_id(customer_id)
      DATABASE.find_by("invoices", "customer_id", customer_id)
    end

    def self.find_by_merchant_id(merchant_id)
      DATABASE.find_by("invoices", "merchant_id", merchant_id)
    end

    def self.find_by_status(status)
      DATABASE.find_by("invoices", "status", status)
    end

    def self.find_by_created_at(time)
      DATABASE.find_by("invoices", "created_at", time)
    end

    def self.find_by_updated_at(time)
      DATABASE.find_by("invoices", "updated_at", time)
    end

    def self.find_all_by_id(id)
      DATABASE.find_all_by("invoices", "id", id)
    end

    def self.find_all_by_customer_id(customer_id)
      DATABASE.find_all_by("invoices", "customer_id", customer_id)
    end

    def self.find_all_by_merchant_id(merchant_id)
      DATABASE.find_all_by("invoices", "merchant_id", merchant_id)
    end

    def self.find_all_by_status(status)
      DATABASE.find_all_by("invoices", "status", status)
    end

    def self.find_all_by_created_at(time)
      DATABASE.find_all_by("invoices", "created_at", time)
    end

    def self.find_all_by_updated_at(time)
      DATABASE.find_all_by("invoices", "updated_at", time)
    end

    def self.find_all_created_on(date)
      DATABASE.find_all_created_on("invoices", date)
    end
  end
end