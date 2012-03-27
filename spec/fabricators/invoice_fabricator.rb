Fabricator(:invoice, :class_name => "SalesEngine::Invoice") do
  id {"invoice #{sequence}"}
end