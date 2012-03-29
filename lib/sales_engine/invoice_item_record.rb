module SalesEngine
  module InvoiceItemRecord
    attr_accessor :db

    def successful_for_merchant(merchant_id)
     invoice_items_array = []
     query = "select * from invoice_items where invoice_id in 
     (select invoices.id from invoices 
      INNER JOIN transactions ON invoices.id = transactions.invoice_id
      where invoices.merchant_id = #{merchant_id}
      AND transactions.result LIKE 'success')"
     Database.instance.db.execute(query)  do |row| 
       invoice_items_array << create_invoice_item(row)
     end
     invoice_items_array
   end

   def successful_for_merchant_and_date(merchant_id, date)
     invoice_items_array = []
     query = "SELECT * FROM invoice_items
     INNER JOIN invoices
     ON invoice_items.invoice_id = invoices.id
     INNER JOIN transactions ON invoices.id = transactions.invoice_id
     WHERE invoices.merchant_id = #{merchant_id}
     AND Date(invoices.created_date) = Date('#{date.to_s}')
     AND transactions.result LIKE 'success'"
     Database.instance.db.execute(query)  do |row| 
       invoice_items_array << create_invoice_item(row)
     end
     invoice_items_array
   end

   def for_item(item_id)
     invoice_items_array = []
     query = "SELECT * FROM invoice_items
              INNER JOIN items ON invoice_items.item_id = items.id
              WHERE items.id = #{item_id}"
     Database.instance.db.execute(query)  do |row| 
       invoice_items_array << create_invoice_item(row)
     end
     invoice_items_array
   end

   def invoice_items 
     invoice_items_array = []
     Database.instance.db.execute("select * from invoice_items") do |row|
       invoice_items_array << create_invoice_item(row)
     end
     invoice_items_array 
   end

   def insert(hash)
    raw_date, clean_date = Database.get_dates
    Database.instance.db.execute("insert into invoice_items values (?, ?, ?, ?, ?, ?, ?, ?, ?)",
      nil, hash[:item_id].to_i, hash[:invoice_id].to_i,
      hash[:quantity], hash[:unit_price],
      raw_date.to_s, raw_date.to_s,
      clean_date, clean_date)
    return Database.instance.db.last_insert_row_id
  end

  private

  def create_invoice_item(row)
   id = row[0].to_i
   item_id = row[1].to_i
   invoice_id = row[2].to_i
   quantity = row[3].to_i
   unit_price = row[4].to_f
   created_at = row[5]
   updated_at = row[6]
   InvoiceItem.new(id, item_id, invoice_id, quantity, unit_price, 
     created_at, updated_at)
 end
end
end
