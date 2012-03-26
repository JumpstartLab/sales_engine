Fabricator(:transaction, :class_name => "SalesEngine::Transaction" ) do
  on_init { init_with("#{sequence :invoice_counter, 1 }",
  1, 16.times.collect { rand(9) }.join, '',
  "success", Date.today, Date.today )}
end