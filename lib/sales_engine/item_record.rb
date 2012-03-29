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
