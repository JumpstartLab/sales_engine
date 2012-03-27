module SalesEngine
  class Merchant
    attr_accessor :id, :name, :created_at, :updated_at

    MERCHANT_ATTS = [
      "id",
      "name",
      "created_at",
      "updated_at"
    ]

    def initialize(attributes)
      self.id = attributes[:id]
      self.name = attributes[:name]
      self.created_at = attributes[:created_at]
      self.updated_at = attributes[:updated_at]
    end

    MERCHANT_ATTS.each do |att|
      define_singleton_method ("find_by_" + att).to_sym do |param|
        SalesEngine::Database.instance.merchant_list.detect do |merchant|
          merchant.send(att.to_sym).to_s.downcase == param.to_s.downcase
        end
      end
    end

    MERCHANT_ATTS.each do |att|
      define_singleton_method ("find_all_by_" + att).to_sym do |param|
        SalesEngine::Database.instance.merchant_list.select do |merchant|
          merchant if merchant.send(att.to_sym).to_s.downcase == param.to_s.downcase
        end
      end
    end

    def items
      SalesEngine::Item.find_all_by_merchant_id(self.id)
    end

    def invoices
      SalesEngine::Invoice.find_all_by_merchant_id(self.id)
    end

    def invoices_on_date(date)
      date = Time.parse(date)
      # debugger
      invoices.select {|inv| inv if inv.updated_at == date}
    end

    def revenue(*date)
      total_revenue = BigDecimal.new("0.00")
      date.empty? ? results = invoices : results = invoices_on_date(date.first)
      # debugger
      results.each { |invoice| total_revenue += invoice.invoice_revenue }
      total_revenue
    end

    def successful_invoices
      results = invoices.select { |inv| inv if inv.is_successful? }
    end

    def favorite_customer
      customer_data = { }

      successful_invoices.each do |invoice|
        customer_data[ invoice.customer_id.to_sym ] ||= 0
        customer_data[ invoice.customer_id.to_sym ] += 1
      end

      customer_data_max = customer_data.max_by{ |k, v| v }
      return nil if customer_data_max.nil?
      SalesEngine::Customer.find_by_id(customer_data_max.first)   
    end

    def customers_with_pending_invoices  
      pending_invoices = invoices - successful_invoices
      pending_invoices.collect do |inv|
        SalesEngine::Customer.find_by_id(inv.customer_id)
      end
    end
  end
end