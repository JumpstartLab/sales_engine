module SalesEngine
  module ItemRecord
     def items 
       items = []
       Database.instance.db.execute("select * from items") do |row|
         id = row[0].to_i
         name = row[1]
         description = row[2]
         unit_price = row[3].to_f
         merchant_id = row[4].to_i
         created_at = row[5]
         updated_at = row[6]
         items << Item.new(id, name, description, unit_price, 
                                 merchant_id, created_at, updated_at)
       end
       items
     end

     def items_sold
       items_array = []
       query = "SELECT * FROM items
                INNER JOIN invoice_items ON items.id = invoice_items.item_id
                INNER JOIN invoices ON invoice_items.invoice_id = invoices.id
                INNER JOIN transactions on invoices.id = transactions.invoice_id
                AND transactions.result LIKE 'success'"
       Database.instance.db.execute(query)  do |row| 
         items_array << create_item(row)
       end
       items_array
     end

      def create_item(row)
       id = row[0].to_i
       name = row[1]
       description = row[2]
       unit_price = row[3].to_f
       merchant_id = row[4].to_i
       created_at = row[5]
       updated_at = row[6]
       Item.new(id, name, description, unit_price, merchant_id, 
         created_at, updated_at)
     end
  end
end
