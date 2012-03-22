module SalesEngine
  class Invoice
    #include SalesEngine::Search
    attr_accessor :id,
                  :customer_id,
                  :merchant_id,
                  :status,
                  :created_at,
                  :updated_at

    def initialize(attributes={})
      self.id = attributes[:id].to_s
      self.customer_id = attributes[:customer_id].to_s
      self.merchant_id = attributes[:merchant_id].to_s
      self.status = attributes[:status].to_s
      self.created_at = attributes[:created_at].to_s
      self.updated_at = attributes[:updated_at].to_s
    end

    def self.invoices
      invoices = []
      ObjectSpace.each_object(SalesEngine::Invoice) {|o| invoices<<o}
      invoices
    end

    def transactions_array
      transactions = []
      ObjectSpace.each_object(SalesEngine::Transaction) {|o| transactions<<o}
      transactions
    end

    def invoice_items_array
      invoice_items = []
      ObjectSpace.each_object(SalesEngine::InvoiceItem) {|o| invoice_items<<o}
      invoice_items
    end

    def items_array
      items = []
      ObjectSpace.each_object(SalesEngine::Item) {|o| items<<o}
      items
    end

    def customers_array
      customers = []
      ObjectSpace.each_object(SalesEngine::Customer) {|o| customers<<o}
      customers
    end


    def self.random
        self.invoices.sample
        self.invoices.sample
    end

    def self.find_by_id(match)
      SalesEngine::Search.find_all_by("id", match, self.invoices).sample
    end

    def self.find_all_by_id(match)
      SalesEngine::Search.find_all_by("id", match, self.invoices)
    end

    def self.find_by_customer_id(match)
      SalesEngine::Search.find_all_by("customer_id", match, self.invoices).sample
    end

    def self.find_all_by_customer_id(match)
      SalesEngine::Search.find_all_by("customer_id", match, self.invoices)
    end

    def self.find_by_merchant_id(match)
      SalesEngine::Search.find_all_by("merchant_id", match, self.invoices).sample
    end

    def self.find_all_by_merchant_id(match)
      SalesEngine::Search.find_all_by("merchant_id", match, self.invoices)
    end

    def self.find_by_status(match)
      SalesEngine::Search.find_all_by("status", match, self.invoices).sample
    end

    def self.find_all_by_status(match)
      SalesEngine::Search.find_all_by("status", match, self.invoices)
    end

    def self.find_by_updated_at(match)
      SalesEngine::Search.find_all_by("updated_at", match, self.invoices).sample
    end

    def self.find_all_by_updated_at(match)
      SalesEngine::Search.find_all_by("updated_at", match, self.invoices)
    end

    def self.find_by_created_at(match)
      SalesEngine::Search.find_all_by("created_at", match, self.invoices).sample
    end

    def self.find_all_by_created_at(match)
      SalesEngine::Search.find_all_by("created_at", match, self.invoices)
    end
    
    def transactions
      transactions = []
      transactions = transactions_array.select { |trans| trans.invoice_id ==  id }
    end

    def invoice_items
      invoice_items = []
      invoice_items = invoice_items_array.select { |inv| inv.invoice_id == id}
    end

    def items
      item_ids =[]
      items_ids = invoice_items.collect {|inv| inv.item_id}
      items = []
      items=items_array.select{|i| items_ids.include?(i.id)}
    end

    def customer
      customer = customers_array.select { |cust| customer_id ==cust.id }
    end

  end
end