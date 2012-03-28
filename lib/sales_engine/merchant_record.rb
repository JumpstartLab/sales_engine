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
end
