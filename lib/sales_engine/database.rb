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

     def transactions 
       transactions = []
       db.execute("select * from transactions") do |row|
         transactions << create_transaction(row)
       end
       transactions 
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

     def transactions_by_customer(customer_id)
       transactions = []
       query = "SELECT transactions.id as transaction_id, invoice_id,
       credit_card_number, credit_card_expiration_date, result,
       transactions.created_at, transactions.updated_at
       FROM invoices
       INNER JOIN transactions ON invoices.id = transactions.invoice_id
       WHERE invoices.customer_id = #{customer_id}"
       db.execute(query) do |row|
         transactions << create_transaction(row)
       end
       transactions
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

     def insert_transaction(hash)
      raw_date, clean_date = Database.get_dates
      db.execute("insert into transactions values (?, ?, ?, ?, ?, ?, ?, ?, ?)",
                  nil, hash[:invoice_id].to_i, hash[:credit_card_number],
                  hash[:credit_card_expiration_date], hash[:result],
                  raw_date.to_s, raw_date.to_s,
                  clean_date, clean_date)
      return db.last_insert_row_id
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

     def create_transaction(row)
       id = row[0]
       invoice_id = row[1]
       credit_card_number = row[2]
       credit_card_expiration_date = row[3]
       result = row[4]
       created_at = row[5]
       updated_at = row[6]
       Transaction.new(id, invoice_id, credit_card_number, 
                       credit_card_expiration_date, result, 
                       created_at, updated_at)
     end
   end
 end 
