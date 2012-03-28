Fabricator(:customer, :class_name => "SalesEngine::Customer") do
  id { sequence }
  first_name { "FirstName" }
  last_name {"LastName"}
end

Fabricator(:customer_with_invoices, :from => :customer) do
  invoices { [Fabricate(:invoice), Fabricate(:invoice)] }
end

Fabricator(:customer_with_merchants, :from => :customer) do
  merchants { [Fabricate(:merchant), Fabricate(:merchant)] }
end