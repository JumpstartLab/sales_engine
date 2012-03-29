module SalesEngine
  module MerchantRecord
     def merchants
       merchants = []
       Database.instance.db.execute("select * from merchants") do |row|
         id = row[0]
         name = row[1]
         created_at = row[2]
         updated_at = row[3]
         merchants << Merchant.new(id, name, created_at, updated_at)
       end
       merchants
     end
  end

  def customers_with_pending_invoices
    query = "select customer_id, invoice_id, result from transactions 
             INNER JOIN invoices on transactions.invoice_id = invoices.id
             WHERE merchant_id = #{id}"

    transaction_hash = {} 
    Database.instance.db.execute(query)  do |row| 
      invoice_id = row[1]
      if row[2] == "success"
         transaction_hash.delete(invoice_id)
      else
        transaction_hash[invoice_id] = row[0]
      end
    end
    
    customer_ids = transaction_hash.values
    query = "SELECT customer_id FROM invoices 
             WHERE id 
             NOT IN(select invoice_id from transactions) 
             AND merchant_id = #{id}"
    Database.instance.db.execute(query) { |row| customer_ids << row[0] }
    customer_ids.collect { |id| Customer.find_by_id(id) } 
  end

  def find_favorite_customer(merchant_id)
    query = "SELECT customer_id, count(customer_id) 
     AS total FROM invoice_items
     INNER JOIN invoices
     ON invoice_items.invoice_id = invoices.id
     INNER JOIN transactions ON invoices.id = transactions.invoice_id
     WHERE invoices.merchant_id = #{merchant_id} 
     AND transactions.result LIKE 'success'
     GROUP BY customer_id"

     most_transactions = 0
     favorite_customer_id = 0
     Database.instance.db.execute(query)  do |row| 
       customer_id = row[0]
       total_transactions = row[1]
       if total_transactions > most_transactions
         most_transactions = total_transactions
         favorite_customer_id = customer_id
       end
     end
     Customer.find_by_id(favorite_customer_id)
  end
end
