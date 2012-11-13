Fabricator(:invoice, :class_name => SalesEngine::Invoice) do
  on_init { init_with({created_at: "02/04/11"}) }
  id { sequence }
  customer_id { rand * 1000 }
  merchant_id { rand * 100 }
  status { Faker::Lorem.words(1).join }
  created_at Time.now
end