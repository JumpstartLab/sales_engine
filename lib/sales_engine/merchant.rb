module SalesEngine
  class Merchant
    extend Searchable
    include Searchable
    attr_accessor :name, :id, :total_revenue, :items_sold
    # attr_accessor :raw_csv

    def self.records
      @merchants ||= HashyHash.new(get_merchants) do |h|
        h.unique :id
      end
    end

    # def self.csv_headers=(value)
    #   @csv_headers=(value)
    # end

    def self.get_merchants
      CSVManager.load('data/merchants.csv').collect do |record|
        Merchant.new(record)
      end
    end

    def self.most_revenue(num_merchants)
      all.sort_by{ |m| - m.total_revenue }.first(num_merchants)
    end

    def self.most_items(num_merchants)
      all.sort_by{ |m| - m.items_sold }.first(num_merchants)
    end

    def self.revenue(dates = nil)
      all.map{ |m| m.revenue(dates) }.inject(:+)
    end

    def self.dates_by_revenue(count = nil)
      dates = Hash.new(0)
      SalesEngine::Invoice.all.each do |invoice|
        dates[invoice.created_at.strftime("%y/%m/%d")] += invoice.total_paid
      end
      dates = dates.sort_by{ |k, v| v }.reverse
      dates = dates.map(&:first).map { |d| DateTime.parse(d) }
      count ? dates.first(count) : dates
    end

    def initialize(raw_line)
      self.name = raw_line[:name]
      self.id = raw_line[:id].to_i
      self.total_revenue = 0
      self.items_sold = 0
      # self.raw_csv = raw_line.values
      # Merchant.csv_headers ||= raw_line.keys
    end

    def items
      @items ||= SalesEngine::Item.find_all_by_merchant_id(self.id)
    end

    def invoices
      @invoices ||= SalesEngine::Invoice.find_all_by_merchant_id(self.id)
    end

    def revenue(dates = nil)
      if dates.is_a?(Range)
        revenue_for_dates(dates)
      elsif dates.is_a?(Date)
        revenue_for_date(dates)
      else
        @total_revenue || 0
      end
    end

    def revenue_for_dates(date_range)
      di = invoices.select do |i|
        first = date_range.first.strftime("%d%m%y")
        last = date_range.last.strftime("%d%m%y")
        compare = i.created_at.strftime("%d%m%y")
        compare >= first && compare <= last
      end
      di.map(&:total_paid).inject(:+) || 0
    end

    def revenue_for_date(date)
      di = invoices.select do |i|
        i.created_at.strftime("%d%m%y") == date.strftime("%d%m%y")
      end
      di.map(&:total_paid).inject(:+) || 0
    end

    def favorite_customer
      favorite_record(Customer)
    end

    def customers_with_pending_invoices
      results = []
      invoices.map(&:customer_id).uniq.each do |cid|
        customer = SalesEngine::Customer.find_by_id(cid)
        results << customer if customer.has_pending_invoices?(self.id)
      end
      results
    end
  end
end


