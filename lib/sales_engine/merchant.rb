require 'sales_engine/item'
require 'sales_engine/model'
require 'bigdecimal'

class SalesEngine
  class Merchant
    ATTRIBUTES = %w(id created_at updated_at name)

    attr_accessor :id, :created_at, :updated_at, :name


    def self.finder_attributes
      ATTRIBUTES
    end

    include Model

    def initialize(attributes)
      super(attributes)
      @name = attributes[:name]
    end

    def items
      SalesEngine::Item.find_all_by_merchant_id(@id)
    end

    def invoices=(input)
      @invoices = input
    end

    def invoices
      @invoices ||= SalesEngine::Invoice.find_all_by_merchant_id(@id)
    end

    def invoices_on_date(date)
      invoices.select {|i| i.updated_at == date}
    end

    def revenue(date=nil)
      result = ''
      if date
        result = invoices_on_date(date).inject(0) do |sum, element|
          sum + element.total
        end
      else
        result = invoices.inject(0) {|sum, element| sum + element.total }
      end
      b = BigDecimal.new(result) / 100
      @revenue ||= b
    end

    def self.revenue(date=nil)
      result = ''
      if date
        result = SalesEngine::Invoice.find_all_by_updated_at(date)
        result.inject(0) do |sum, element|
          sum + element.total
        end
      else
        result =  SalesEngine::Invoice.invoices.inject(0) do |sum, element|
          sum + element.total
        end
      end
      result
    end

    def set_revenue=(input)
      @revenue = input
    end

    def customers
      invoices.collect{ |invoice| invoice.customer }
    end

    def favorite_customer
      grouped_by_customer = invoices.group_by{|invoice| invoice.customer}
      std_and_gpd_by_cstmr = grouped_by_customer.sort_by do |customer,invoices|
        invoices.count
      end
      customer_and_invoices = std_and_gpd_by_cstmr.last
      customer = customer_and_invoices.first
    end

    def self.add_to_db(merch)
      if self.find_by_id(merch.id) == nil
        SalesEngine::Database.instance.merchants << merch
      end
    end
  end
end
