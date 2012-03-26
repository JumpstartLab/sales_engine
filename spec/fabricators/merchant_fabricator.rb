Fabricator(:merchant, :class_name => "SalesEngine::Merchant" ) do
  on_init { init_with("#{sequence :merchant_counter, 1 }",
  "#{Faker::Name.first_name} #{Faker::Name.last_name}",
  Date.today, Date.today )}
end