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
         id = row[0]
         invoice_id = row[1]
         credit_card_number = row[2]
         credit_card_expiration_date = row[3]
         result = row[4]
         created_at = row[5]
         updated_at = row[6]
         transactions << Transaction.new(id, invoice_id, credit_card_number, 
                                         credit_card_expiration_date, result, 
                                         created_at, updated_at)
       end
       transactions 
     end

     def invoice_items 
       invoice_items = []
       db.execute("select * from invoice_items") do |row|
         id = row[0]
         item_id = row[1]
         invoice_id = row[2]
         quantity = row[3]
         unit_price = row[4]
         created_at = row[5]
         updated_at = row[6]
         invoice_items << InvoiceItem.new(id, item_id, invoice_id, quantity,
                                         unit_price, created_at, updated_at)
       end
       invoice_items 
     end

     private_class_method :new
   end
 end 


#module SalesEngine
  #class Database
    #class << self
      #attr_accessor :merchants, :invoices, :items,
                    #:invoice_items, :transactions, :customers                    
    #end
  #end
#end 
