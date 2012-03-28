 require 'singleton'

 module SalesEngine
   class Database
     include Singleton
     attr_accessor :db

     def customers 
       customers = []
       db.execute("select * from customers") do |row|
         id = row[0]
         first_name = row[1]
         last_name = row[2]
         created_at = row[5]
         updated_at = row[6]
         customers << Customer.new(id, first_name, last_name, 
                                   created_at, updated_at)
       end
       customers 
     end

     def customers_by_merchant(merchant_id)
       customers = []
       query = "select * from customers
                INNER JOIN invoices on customers.id = invoices.customer_id
                where invoices.merchant_id = #{merchant_id}"
       db.execute(query)  do |row| 
         customers << create_customer(row)
       end
      customers
     end

     def popular_customers(merchant_id)
      customers = {}
      query = "SELECT invoices.customer_id, COUNT(transactions.id)
              FROM merchants
              INNER JOIN invoices ON merchants.id = invoices.merchant_id
              INNER JOIN transactions ON invoices.id = transactions.invoice_id
              WHERE merchant_id = 1
              GROUP BY invoices.customer_id"
       db.execute(query) do |row|
         customers[row[0]] = row[1]
       end
      customers
     end

    def self.get_dates
      raw_date = DateTime.now
      clean_date = raw_date.strftime("%Y-%m-%d %H:%M:%S")
      return raw_date, clean_date
    end

     private_class_method :new

     private

     def create_customer(row)
      id = row[0]
      last_name = row[1]
      first_name = row[2]
      created_at = row[3]
      updated_at = row[4]
      Customer.new(id, last_name, first_name,
                   created_at, updated_at)
     end
   end
 end 
