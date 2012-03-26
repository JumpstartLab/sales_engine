# invoice_items = []
# 1000.times do |i|
#   i_id = rand(1..100)
#   invoice_items << Fabricator("invoice_item#{i}".to_sym, :class_name => "SalesEngine::InvoiceItem") do
#     id i
#     invoice_id rand(1..100)
#     item_id i_id
#     quantity rand(1..50)
#     unit_price rand(1..10)
#     created_at Date.today
#     updated_at Date.today
#   end
# end
# SalesEngine::Database.instance.invoice_item = invoice_items