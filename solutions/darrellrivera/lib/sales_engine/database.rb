module SalesEngine
  class Database
    include Singleton
    CSV_OPTIONS = {:headers => true, :header_converters => :symbol}
    TABLES = [["invoices", SalesEngine::Invoice],
              ["merchants", SalesEngine::Merchant],
              ["items", SalesEngine::Item],
              ["customers", SalesEngine::Customer], 
              ["invoice_items", SalesEngine::InvoiceItem],
              ["transactions", SalesEngine::Transaction]]
    EVAL_DATA_DIR = "./data"
    attr_accessor :merchants, :items, :invoices, :transactions,
                  :customers, :invoiceitems

    def initialize
      clear_all_data
    end

    def clear_all_data
      clear_first_half
      clear_second_half
    end

    def clear_first_half
      clear_merchants_data
      clear_items_data
      clear_invoices_data
    end

    def clear_second_half
      clear_transactions_data
      clear_customers_data
      clear_invoice_items_data
    end

    def clear_merchants_data
      self.merchants = []
    end

    def clear_items_data
      self.items = []
    end

    def clear_invoices_data
      self.invoices = []
    end

    def clear_transactions_data
      self.transactions = []
    end

    def clear_customers_data
      self.customers = []
    end

    def clear_invoice_items_data
      self.invoiceitems = []
    end

    def get_random_record(class_name)
      self.send(class_name)[rand(self.send(class_name).count)]
    end

    def load_tables
      TABLES.each { |table_info| load_data(table_info.first, table_info.last) }
    end

    def load_data(list_name, factory, filename=nil)
      filename ||= "#{EVAL_DATA_DIR}/#{list_name}.csv"
      @file = CSV.open(filename, CSV_OPTIONS)
      self.send(list_name) = @file.collect {|line| factory.new(line)}
      # TBD
    end

    # def load_merchants_data(filename="#{EVAL_DATA_DIR}/merchants.csv")
    #   @file = CSV.open(filename, CSV_OPTIONS)
    #   self.merchants = @file.collect {|line| SalesEngine::Merchant.new(line) }
    # end

    # def load_items_data(filename="#{EVAL_DATA_DIR}/items.csv")
    #   @file = CSV.open(filename, CSV_OPTIONS)
    #   self.items = @file.collect {|line| SalesEngine::Item.new(line) }
    # end

    # def load_invoices_data(filename="#{EVAL_DATA_DIR}/invoices.csv")
    #   @file = CSV.open(filename, CSV_OPTIONS)
    #   self.invoices = @file.collect {|line| SalesEngine::Invoice.new(line) }
    # end

    # def load_customers_data(filename="#{EVAL_DATA_DIR}/customers.csv")
    #   @file = CSV.open(filename, CSV_OPTIONS)
    #   self.customers = @file.collect {|line| SalesEngine::Customer.new(line) }
    # end

    # def load_invoice_items_data(filename="#{EVAL_DATA_DIR}/invoice_items.csv")
    #   @file = CSV.open(filename, CSV_OPTIONS)
    #   self.invoiceitems = @file.collect {|line|
    #     SalesEngine::InvoiceItem.new(line) }
    # end

    # def load_transactions_data(filename="#{EVAL_DATA_DIR}/transactions.csv")
    #   @file = CSV.open(filename, CSV_OPTIONS)
    #   self.transactions = @file.collect {|line|
    #     SalesEngine::Transaction.new(line) }
    # end

    def add_to_list(thing)
      self.send(thing.class.to_s.split("::").last.downcase+"s") << thing
    end

    def find_by(class_name,attribute,search_value)
      self.send(class_name).find { |record|
        attribute_value = record.send(attribute)
        if attribute_value.is_a?(String)
          attribute_value.downcase == search_value.to_s.downcase
        else
          attribute_value == search_value
        end }
    end

    def find_all_by(class_name,attribute,search_value)
      self.send(class_name).find_all { |record|
        attribute_value = record.send(attribute)
        if attribute_value.is_a?(String)
          attribute_value.downcase == search_value.to_s.downcase
        else
          attribute_value == search_value
        end }
    end

    def find_all_items_by_merchant_id(id)
      item_list = []
      self.items.each do |item|
        if item && item.merchant_id && item.merchant_id == id
          item_list << item
        end
      end
      item_list.sort_by { |item| item.merchant_id }
    end

    def find_all_invoices_by_merchant_id(id)
      invoice_list = []
      self.invoices.each do |invoice|
        if invoice && invoice.merchant_id && invoice.merchant_id == id
          invoice_list << invoice
        end
      end
      invoice_list.sort_by { |invoice| invoice.merchant_id }
    end

    def find_all_created_on(class_name, date)
      start_time = Time.parse("#{date} 00:00:00 UTC")
      end_time   = Time.parse("#{date} 23:59:59 UTC")
      self.send(class_name).find_all { |record|
        Time.parse(record.created_at) >= start_time &&
          Time.parse(record.created_at) <= end_time }
    end
  end
end