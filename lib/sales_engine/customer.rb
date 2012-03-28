module SalesEngine
  class Customer

    attr_accessor :id,
                  :first_name,
                  :last_name,
                  :created_at,
                  :updated_at

    def initialize(attributes={})
      self.id = attributes[:id].to_i
      self.first_name = attributes[:first_name].to_s
      self.last_name = attributes[:last_name].to_s
      self.created_at = attributes[:created_at].to_s
      self.updated_at = attributes[:updated_at].to_s
    end


    def self.customers
      DataStore.instance.customers
    end

    def invoices_array
      DataStore.instance.invoices
    end

    def transcations_array
      DataStore.instance.transactions
    end

    def self.random
        self.customers.sample
    end


    def self.method_missing(method_name, *args, &block)
      if method_name =~ /^find_by_(\w+)$/
        Search.find_by_attribute($1, args.first, self.customers)
      elsif method_name =~ /^find_all_by_(\w+)$/
        Search.find_all_by_attribute($1, args.first, self.customers)
      else
        super
      end
    end

    def invoices
      @invoices ||= invoices_array.select { |inv| inv.customer_id == id}
    end

    def successful_invoices
      invoices.select { |invoice| invoice.successful? }
    end

    def invoices=(input)
      @invoices = input
    end

    def merchants=(input)
      @merchants = input
    end

    def invoice_ids
      invoices.collect {|inv| inv.id}
    end

    def transactions
      transcations_array.select {|trans| invoice_ids.include?(trans.invoice_id)}
    end

    def merchant_ids
      successful_invoices.collect {|inv| inv.merchant_id}
    end

    def merchants_hash
      merchants_hash = {}
      merchant_ids.each do |merchant|
        if merchants_hash.has_key?(merchant)
          merchants_hash[merchant] += 1
        else
          merchants_hash[merchant] = 1
        end
      end
      merchants_hash
    end

    def favorite_merchant
      unless merchants_hash == {}
        merch_id = merchants_hash.sort_by{ |merchant, count| count}.reverse.first[0]
        Merchant.find_by_id(merch_id)
      end
    end
  end
end

