Fabricator(:invoice, :class_name => "SalesEngine::Invoice") do
  id { sequence }
end