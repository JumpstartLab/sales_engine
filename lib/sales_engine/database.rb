# require 'singleton'

# module SalesEngine
#   class Database
#     include Singleton
#     # attr_accessor :merchants, :invoices, :items,
#     #                  :invoice_items, :transactions, 
#     #                  :customers, :database                    
#     attr_accessor :db
#     # class << self
#     #   attr_accessor :merchants, :invoices, :items,
#     #                 :invoice_items, :transactions, :customers                    
#     # end

#     def merchants
#       merchants = []
#       db.execute("select * from merchants") do |row|
#         id = row[0]
#         name = row[1]
#         created_at = row[2]
#         updated_at = row[3]
#         merchants << Merchant.new(id, name, created_at, updated_at)
#       end
#       merchants
#     end
 
#     private_class_method :new
#   end
# end 


module SalesEngine
  class Database
    class << self
      attr_accessor :merchants, :invoices, :items,
                    :invoice_items, :transactions, :customers                    
    end
  end
end 