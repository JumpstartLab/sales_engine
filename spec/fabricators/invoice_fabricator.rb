# invoices = []
# 100.times do |i|
#   invoices << Fabricator("invoice#{i}".to_sym, :class_name => "SalesEngine::Invoice") do
#     id i
#     customer_id rand(1..30)
#     merchant_id rand(1..10)
#     status "shipped"
#     created_at Date.today
#     updated_at Date.today
#   end
# end
# SalesEngine::Database.instance.invoice = invoices
