module SalesEngine
  module ItemRecord
     def items 
       items = []
       Database.instance.db.execute("select * from items") do |row|
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
  end
end
