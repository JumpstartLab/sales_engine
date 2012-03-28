Gem::Specification.new do |s|
  s.name        = 'sales_engine'
  s.version     = '0.1.0'
  s.summary     = "The sales engine project from Hungry Academy!"
  s.description = "The sales engine project from Hungry Academy! The sales engine project from Hungry Academy!"
  s.authors     = ["Ed Weng", "Elise Worthy"]
  s.email       = 'elise.worthy+edweng@gmail.com'
  s.files       = ["lib/sales_engine.rb",
                   "lib/sales_engine/csv_loader.rb", 
                   "lib/sales_engine/customer.rb", 
                   "lib/sales_engine/database.rb", 
                   "lib/sales_engine/dynamic_finder.rb",
                   "lib/sales_engine/invoice.rb",
                   "lib/sales_engine/invoice_item.rb",
                   "lib/sales_engine/merchant.rb",
                   "lib/sales_engine/transaction.rb"]
  s.homepage    = 'https://github.com/eweng/sales_engine'
end