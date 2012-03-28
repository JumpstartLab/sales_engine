Fabricator(:item, :class_name => 'SalesEngine::Item') do
  on_init { 
    init_with(
      :id => (1..10).to_a.sample,
      :name => Faker::Lorem.words(1).join.capitalize,
      :description => Faker::Lorem.paragraph,
      :unit_price => (1..100000).to_a.sample,
      :merchant_id => 1
    )
  }
end
