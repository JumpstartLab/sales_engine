Fabricator(:item, :class_name => "SalesEngine::Item") do
  on_init {init_with("#{sequence :item_counter, 1}", Faker::Lorem.words(1).join, 
                      Faker::Lorem.words(10).join(" "), rand(10000),
                      1, Date.today, Date.today)}
end