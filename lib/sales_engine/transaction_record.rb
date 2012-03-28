module SalesEngine
  module TransactionRecord

     def transactions 
       transactions = []
       Database.instance.db.execute("select * from transactions") do |row|
         transactions << create_transaction(row)
       end
       transactions 
     end

     def for_customer(customer_id)
       transactions = []
       query = "SELECT transactions.id as transaction_id, invoice_id,
       credit_card_number, credit_card_expiration_date, result,
       transactions.created_at, transactions.updated_at
       FROM invoices
       INNER JOIN transactions ON invoices.id = transactions.invoice_id
       WHERE invoices.customer_id = #{customer_id}"
       Database.instance.db.execute(query) do |row|
         transactions << create_transaction(row)
       end
       transactions
     end

     def insert(hash)
      raw_date, clean_date = Database.get_dates
      Database.instance.db.execute("insert into transactions values (?, ?, ?, ?, ?, ?, ?, ?, ?)",
                  nil, hash[:invoice_id].to_i, hash[:credit_card_number],
                  hash[:credit_card_expiration_date], hash[:result],
                  raw_date.to_s, raw_date.to_s,
                  clean_date, clean_date)
      return Database.instance.db.last_insert_row_id
     end

     private 

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
