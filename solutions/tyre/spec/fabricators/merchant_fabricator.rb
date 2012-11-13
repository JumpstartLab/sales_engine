# merchants = []
# 10.times do |i|
#   Fabricator("merchant#{i}".to_sym, :class_name => "SalesEngine::Merchant") do
#     id i
#     name Faker::Company.name
#     created_at Date.today
#     updated_at Date.today
#   end
# end
# SalesEngine::Database.instance.merchant = merchants
