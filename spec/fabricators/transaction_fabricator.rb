Fabricator(:transaction, :class_name => "SalesEngine::Transaction") do
  id      { sequence }
  result  "Success"
end