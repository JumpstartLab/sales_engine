Fabricator(:invoice, :class_name => "SalesEngine::Invoice" ) do
  on_init { init_with("#{sequence :invoice_counter, 1 }",
  1, 1, "shipped",
  Date.today, Date.today )}
end