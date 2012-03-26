# transactions = []

# 100.times do |i|
#   Fabricator("transaction#{i}".to_sym, :class_name => "SalesEngine::Transaction") do
#     id i
#     invoice_id i
#     credit_card_number rand(1000000000000000..9999999999999999)
#     credit_card_expiration Date.today
#     result "success"
#     created_at Date.today
#     updated_at Date.today
#   end
# end
# SalesEngine::Database.instance.transaction = transactions
