Fabricator(:customer, :class_name => 'SalesEngine::Customer') do
  on_init { 
    init_with(
      :id => (1..10).to_a.sample,
      :first_name => Faker::Name.first_name, 
      :last_name => Faker::Name.last_name
    )
  }
end
