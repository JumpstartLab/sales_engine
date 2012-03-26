# items = []
# 100.times do |i|
#   Fabricator("item#{i}".to_sym, :class_name => "SalesEngine::Item") do
#     id i
#     name Faker::Lorem.words(num = 1)
#     description Faker::Lorem.sentences(sentence_count = 1)
#     unit_price i*1.5
#     merchant_id rand(1..10)
#     created_at Date.today
#     updated_at Date.today
#   end
# end
# SalesEngine::Database.instance.item = items
