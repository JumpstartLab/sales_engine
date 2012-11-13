module SalesEngine
  class Invoice
    #include SalesEngine::Search
    attr_accessor :id,
                  :customer_id,
                  :merchant_id,
                  :status,
                  :created_at,
                  :updated_at,
                  :date

    def initialize(attributes={})
      self.id = attributes[:id].to_i
      self.customer_id = attributes[:customer_id].to_i
      self.merchant_id = attributes[:merchant_id].to_i
      self.status = attributes[:status].to_s
      self.created_at = Date.parse(attributes[:created_at])
      self.updated_at = Date.parse(attributes[:updated_at])
      self.date = Date.parse(attributes[:created_at])
    end

    def self.method_missing(method_name, *args, &block)
      if method_name =~ /^find_by_(\w+)$/
        Search.find_by_attribute($1, args.first, self.invoices)
      elsif method_name =~ /^find_all_by_(\w+)$/
        Search.find_all_by_attribute($1, args.first, self.invoices)
      else
        super
      end
    end

    def self.invoices
      invoices = DataStore.instance.invoices
    end

    def transactions_array
      transactions = DataStore.instance.transactions
    end

    def invoice_items_array
      invoice_items = DataStore.instance.invoice_items
    end

    def items_array
      items = DataStore.instance.items
    end

    def customers_array
      customers = DataStore.instance.customers
    end

    def self.random
      self.invoices.sample
    end

    def transactions
      @transactions ||= transactions_array.select { |t| t.invoice_id == id }
    end

    def invoice_items
      @invoice_items ||= invoice_items_array.select { |i| i.invoice_id == id}
    end

    def items
      items_ids = invoice_items.collect { |inv| inv.item_id}
      items_array.select{ |i| items_ids.include?(i.id)}
    end

    def customer
      customer = customers_array.detect { |cust| customer_id == cust.id }
    end

    def successful?
      passed_trans = transactions.select { |trans| trans.result == "success"}
      if passed_trans.count >0
        true
      elsif passed_trans.count == 0
        false
      end
    end

    def revenue
      if successful?
        rev = 0
        invoice_items.each do |inv_item|
          rev += inv_item.total
        end
      else
        rev = 0
      end
      rev
    end

    def self.create(attributes)
      new_invoice_id = DataStore.instance.invoices.count + 1
      invoice = SalesEngine::Invoice.new(:id => new_invoice_id,
        :customer_id => attributes[:customer].id,
        :merchant_id => attributes[:merchant].id,
        :status => attributes[:status],
        :created_at => Time.now.utc.to_s,
        :updated_at => Time.now.utc.to_s)
      DataStore.instance.invoices << invoice
      self.item_hash(attributes, new_invoice_id)
      invoice
    end

    def self.item_hash(attributes, new_invoice_id)
      item_hash={}
      attributes[:items].each do |item|
        if item_hash.has_key?(item)
          item_hash[item] += 1
        else
          item_hash[item] = 1
        end
      end
      self.create_inv_items(item_hash, new_invoice_id)
    end

    def self.create_inv_items(item_hash, new_invoice_id)
      increment = 1
      item_hash.each do |item, quantity|
        invoice_item = SalesEngine::InvoiceItem.new(
          :id=> DataStore.instance.invoice_items.count + increment,
          :invoice_id => new_invoice_id,
          :item_id => item.id,
          :quantity => quantity,
          :unit_price => item.unit_price,
          :created_at => Time.now.utc.to_s,
          :updated_at => Time.now.utc.to_s)
        DataStore.instance.invoice_items << invoice_item
        increment += 1
      end
    end

    def charge(attributes)
      new_transaction_id = DataStore.instance.transactions.count + 1
      transaction = SalesEngine::Transaction.new(:id => new_transaction_id,
        :credit_card_number => attributes[:credit_card_number],
        :credit_card_expiration_date =>
          attributes[:credit_card_expiration_date],
        :invoice_id => id,
        :result => attributes[:result],
        :created_at => Time.now.utc.to_s,
        :updated_at => Time.now.utc.to_s)
      DataStore.instance.transactions << transaction
      transactions << transaction
      transaction
    end
  end
end

