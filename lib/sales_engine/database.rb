 require 'singleton'

 module SalesEngine
   class Database
     include Singleton
     attr_accessor :db

     def merchants
       merchants = []
       db.execute("select * from merchants") do |row|
         id = row[0]
         name = row[1]
         created_at = row[2]
         updated_at = row[3]
         merchants << Merchant.new(id, name, created_at, updated_at)
       end
       merchants
     end

     def invoices
       invoices = []
       db.execute("select * from invoices") do |row|
         id = row[0]
         customer_id = row[1]
         merchant_id = row[2]
         status = row[3]
         created_at = row[4]
         updated_at = row[5]
         invoices << Invoice.new(id, customer_id, merchant_id, status, 
                                  created_at, updated_at)
       end
       invoices
     end

     def items 
       items = []
       db.execute("select * from items") do |row|
         id = row[0]
         name = row[1]
         description = row[2]
         unit_price = row[3]
         merchant_id = row[4]
         created_at = row[5]
         updated_at = row[6]
         items << Item.new(id, name, description, unit_price, 
                                 merchant_id, created_at, updated_at)
       end
       items
     end

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

     def invoice_items 
       invoice_items = []
       db.execute("select * from invoice_items") do |row|
         invoice_items << create_invoice_item(row)
       end
       invoice_items 
     end
      
     def invoice_items_by_merchant(merchant_id)
       invoice_items = []
       query = "select * from invoice_items where invoice_id in 
       (select id from invoices where merchant_id = #{merchant_id})"
       db.execute(query)  do |row| 
         invoice_items << create_invoice_item(row)
       end
      invoice_items
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

     private_class_method :new

     private

     def create_invoice_item(row)
       id = row[0]
       item_id = row[1]
       invoice_id = row[2]
       quantity = row[3]
       unit_price = row[4]
       created_at = row[5]
       updated_at = row[6]
       InvoiceItem.new(id, item_id, invoice_id, quantity, unit_price, 
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
