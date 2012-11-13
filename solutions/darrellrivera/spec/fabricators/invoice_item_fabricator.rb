Fabricator(:invoice_item, :class_name => "SalesEngine::InvoiceItem") do
  id          { sequence }
  quantity    1
  unit_price  1
end