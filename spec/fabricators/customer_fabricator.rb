Fabricator(:customer, :class_name => "SalesEngine::Customer" ) do
  on_init { init_with("#{sequence :customer_counter, 1 }",
  "#{Faker::Name.first_name}", "#{Faker::Name.last_name}",
  Date.today, Date.today )}
end