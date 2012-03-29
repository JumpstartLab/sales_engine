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

     def invoice_items_sold_for(item_id)
       invoice_items_array = []
       query = "SELECT * FROM invoice_items
                INNER JOIN invoices ON invoice_items.invoice_id = invoices.id
                INNER JOIN transactions on invoices.id = transactions.invoice_id
                WHERE invoice_items.item_id = #{item_id}
                AND transactions.result LIKE 'success'"
       Database.instance.db.execute(query)  do |row| 
         invoice_items_array << create_invoice_item(row)
       end
       invoice_items_array
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
