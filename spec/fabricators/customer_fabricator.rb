Fabricator(:customer, :class_name => "SalesEngine::Customer") do
  id { sequence }
end

Fabricator(:customer_with_invoices, :from => :customer) do
  invoices { [Fabricate(:invoice), Fabricate(:invoice)] }
end