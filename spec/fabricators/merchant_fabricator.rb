Fabricator(:merchant, :class_name => 'SalesEngine::Merchant') do
  on_init { 
    init_with(
      :id => (1..10).to_a.sample, 
      :name => Faker::Company.name
    ) 
  }
end
