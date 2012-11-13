Fabricator(:merchant, :class_name => "SalesEngine::Merchant") do
  id {"merchant #{sequence}"}
end