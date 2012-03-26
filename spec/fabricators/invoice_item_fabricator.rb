Fabricator(:invoice_item, :class_name => "SalesEngine::InvoiceItem" ) do
  on_init { init_with("#{sequence :invoice_counter, 1 }",
  1, 1, rand(10000), rand(10000),
  Date.today, Date.today )}
end