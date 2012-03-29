Gem::Specification.new do |s|
  s.name        = "sales_engine"
  s.version     = 1.0
  s.authors     = ["Mike Chlipala", "Mary Cutrali"]
  s.email       = ["mchlipala+maryelizbeth+mikesea@gmail.com"]
  s.homepage    = "https://github.com/mikesea/sales_engine"
  s.summary     = "Sales Engine"
  s.description = "Hungry Academy project #2"

  s.files       = ["lib/sales_engine.rb",
                   "lib/sales_engine/database.rb", 
                   "lib/sales_engine/customer.rb", 
                   "lib/sales_engine/invoice.rb",
                   "lib/sales_engine/invoice_item.rb",
                   "lib/sales_engine/item.rb",
                   "lib/sales_engine/merchant.rb",
                   "lib/sales_engine/transaction.rb",
                   "lib/sales_engine/find.rb" ]
end