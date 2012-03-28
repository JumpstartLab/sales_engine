module SalesEngine
  module InvoiceItemRecord
    attr_accessor :db

    def for_merchant(merchant_id)
     invoice_items = []
     query = "select * from invoice_items where invoice_id in 
     (select id from invoices where merchant_id = #{merchant_id})"
     Database.instance.db.execute(query)  do |row| 
       invoice_items << create_invoice_item(row)
     end
     invoice_items
   end

   def for_merchant_and_date(merchant_id, date)
     invoice_items = []
     query = "SELECT * FROM invoice_items
     INNER JOIN invoices
     ON invoice_items.invoice_id = invoices.id
     WHERE invoices.merchant_id = 1
     AND Date(invoices.created_date) = Date('#{date.to_s}')"
     Database.instance.db.execute(query)  do |row| 
       invoice_items << create_invoice_item(row)
     end
     invoice_items
   end

   def invoice_items 
     invoice_items = []
     Database.instance.db.execute("select * from invoice_items") do |row|
       invoice_items << create_invoice_item(row)
     end
     invoice_items 
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
end
end