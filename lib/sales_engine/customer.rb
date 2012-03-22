module SalesEngine
  class Customer
    #extend SalesEngine::Search
    attr_accessor :id,
                  :first_name,
                  :last_name,
                  :created_at,
                  :updated_at

    def initialize(attributes={})
      self.id = attributes[:id].to_s
      self.first_name = attributes[:first_name].to_s
      self.last_name = attributes[:last_name].to_s
      self.created_at = attributes[:created_at].to_s
      self.updated_at = attributes[:updated_at].to_s
    end


    def self.customers
      customers = []
      ObjectSpace.each_object(SalesEngine::Customer) {|o| customers<<o}
      customers
    end

    def invoices_array
      invoices = []
      ObjectSpace.each_object(SalesEngine::Invoice) {|o| invoices<<o}
      invoices
    end

    def self.random
        self.customers.sample
    end

    def self.find_by_id(match)
      SalesEngine::Search.find_all_by("id", match, self.customers).sample
    end

    def self.find_all_by_id(match)
      SalesEngine::Search.find_all_by("id", match, self.customers)
    end

    def self.find_by_first_name(match)
      SalesEngine::Search.find_all_by("first_name", match, self.customers).sample
    end

    def self.find_all_by_first_name(match)
      SalesEngine::Search.find_all_by("first_name", match, self.customers)
    end

    def self.find_by_last_name(match)
      SalesEngine::Search.find_all_by("last_name", match, self.customers).sample
    end

    def self.find_all_by_last_name(match)
      SalesEngine::Search.find_all_by("last_name", match, self.customers)
    end

    def self.find_by_updated_at(match)
      SalesEngine::Search.find_all_by("updated_at", match, self.customers).sample
    end

    def self.find_all_by_updated_at(match)
      SalesEngine::Search.find_all_by("updated_at", match, self.customers)
    end

    def self.find_by_created_at(match)
      SalesEngine::Search.find_all_by("created_at", match, self.customers).sample
    end

    def self.find_all_by_created_at(match)
      SalesEngine::Search.find_all_by("created_at", match, self.customers)
    end

    def invoices
      invoices = []
      invoices = invoices_array.select { |inv| inv.customer_id == id}
    end
  end
end

