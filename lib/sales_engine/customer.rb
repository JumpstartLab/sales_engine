module SalesEngine
  class Customer
    #extend SalesEngine::Search
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
      customers = DataStore.instance.customers
    end

    def invoices_array
      invoices = DataStore.instance.invoices
    end

    def transcations_array
      transactions = DataStore.instance.transactions
    end

    def self.random
        self.customers.sample
    end

    def self.find_by_id(match)
      SalesEngine::Search.find_by("id", match, self.customers)
    end

    def self.find_all_by_id(match)
      SalesEngine::Search.find_all_by("id", match, self.customers)
    end

    def self.find_by_first_name(match)
      SalesEngine::Search.find_by("first_name", match, self.customers)
    end

    def self.find_all_by_first_name(match)
      SalesEngine::Search.find_all_by("first_name", match, self.customers)
    end

    def self.find_by_last_name(match)
      SalesEngine::Search.find_by("last_name", match, self.customers)
    end

    def self.find_all_by_last_name(match)
      SalesEngine::Search.find_all_by("last_name", match, self.customers)
    end

    def self.find_by_updated_at(match)
      SalesEngine::Search.find_by("updated_at", match, self.customers)
    end

    def self.find_all_by_updated_at(match)
      SalesEngine::Search.find_all_by("updated_at", match, self.customers)
    end

    def self.find_by_created_at(match)
      SalesEngine::Search.find_by("created_at", match, self.customers)
    end

    def self.find_all_by_created_at(match)
      SalesEngine::Search.find_all_by("created_at", match, self.customers)
    end

    def invoices
      #@invoices || invoices_array.select { |inv| inv.customer_id == id}
      invoices_array.select { |inv| inv.customer_id == id}
    end

    def invoices=(input)
      @invoices = input
    end

    def invoice_ids
      invoice_ids = []
      invoices.each do |inv|
        invoice_ids << inv.id
      end
      invoice_ids
    end

    def transactions
      transcations_array.select {|trans| invoice_ids.include?(trans.invoice_id)}
    end

    def any_rejected
      any = ""
      rejected = transactions.select {|transaction| transaction.result != "success"}
      if rejected.length >0
        any = "yes"
      elsif rejected.length ==0
        any = "no"
      end
    end

    def merchants_array
      merchants = []
      invoices.each do |invoice|
        merchants << invoice.merchant_id
      end
      merchants
    end

    def favorite_merchant
      merchants_hash = {}
      merchants_array.each do |merchant|
        if merchants_hash.has_key?(merchant)
          merchants_hash[merchant] += 1
        else
          merchants_hash[merchant] = 1
        end
      end
      merch_id = merchants_hash.max_by{ |merchant, count| count}[0]
      Merchant.find_by_id(merch_id)
    end
  end
end

