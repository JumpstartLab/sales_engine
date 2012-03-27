Fabricator(:invoice_item, :class_name => "SalesEngine::InvoiceItem") do
  id          { sequence }
  unit_price  1
end