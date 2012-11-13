# customers = []
# 30.times do |i|
# customers << Fabricator("customer#{i}".to_sym, :class_name => "SalesEngine::Customer") do
#     id i
#     first_name Faker::Name.first_name
#     last_name Faker::Name.last_name
#     created_at Date.today
#     updated_at Date.today
#   end
# end
# SalesEngine::Database.instance.customer = customers