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

  def favorite_customer
    query = "SELECT customer_id, count(customer_id) 
     AS total FROM invoice_items
     INNER JOIN invoices
     ON invoice_items.invoice_id = invoices.id
     INNER JOIN transactions ON invoices.id = transactions.invoice_id
     WHERE invoices.merchant_id = #{id} 
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

  def revenue(date)
    query = "SELECT SUM(invoice_items.quantity*invoice_items.unit_price) 
             FROM invoices
             INNER JOIN invoice_items ON invoices.id = invoice_items.invoice_id
             INNER JOIN transactions ON invoices.id = transactions.invoice_id
             WHERE transactions.result LIKE 'success'" 

    if date 
      query += " AND Date(invoices.created_date) = Date('#{date.to_s}')"
    end

    result = 0
    Database.instance.db.execute(query)  do |row| 
      result += row[0]
    end
    BigDecimal.new(result.to_s).round(2)
  end

  def most_items(total_merchants)
    query = "SELECT merchants.id, SUM(quantity) FROM invoice_items
             INNER JOIN invoices ON invoice_items.invoice_id = invoices.id
             INNER JOIN merchants ON invoices.merchant_id = merchants.id
             INNER JOIN transactions ON invoices.id = transactions.invoice_id
             WHERE transactions.result LIKE 'success'
             GROUP BY merchants.id ORDER BY SUM(quantity) DESC
             limit #{total_merchants}"

    results = []
    Database.instance.db.execute(query)  do |row| 
      puts row[0]
      results << Merchant.find_by_id(row[0])
    end
    results
  end

  def most_revenue(total_merchants)
      invoice_items_array = []
      query = "SELECT merchant_id, SUM(quantity * unit_price) as sum 
            FROM invoice_items
            INNER JOIN invoices ON invoice_items.invoice_id = invoices.id
            INNER JOIN transactions on invoices.id = transactions.invoice_id
            AND transactions.result LIKE 'success'
            GROUP BY merchant_id 
            ORDER BY sum DESC"

    results = []
    Database.instance.db.execute(query)  do |row| 
      if results.length < total_merchants 
        results << Merchant.find_by_id(row[0])
      else
        break
      end
    end
    results
  end
end
end
