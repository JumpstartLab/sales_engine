Fabricator(:invoice_item, :class_name => "SalesEngine::InvoiceItem") do
  id { sequence }
end