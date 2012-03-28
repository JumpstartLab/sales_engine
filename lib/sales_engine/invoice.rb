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
      self.created_at = attributes[:created_at].to_s
      self.updated_at = attributes[:updated_at].to_s
      self.date = attributes[:created_at].to_s[0..9]
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
      transactions_array.select { |trans| trans.invoice_id ==  id }
    end

    def invoice_items
      invoice_items_array.select { |inv| inv.invoice_id == id}
    end

    def items
      items_ids = invoice_items.collect { |inv| inv.item_id}
      items_array.select{ |i| items_ids.include?(i.id)}
    end

    def customer
      customer = customers_array.detect { |cust| customer_id == cust.id }
    end

    def successful?
      passed_trans = transactions.select { |transaction| transaction.result == "success"}
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

  end
end