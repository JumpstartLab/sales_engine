Fabricator(:merchant, :class_name => "SalesEngine::Merchant") do
  on_init { init_with( { :id => "100", :name => "#{sequence} Jakubowski, Buckridge and Kovacek",
 :created_at => "2012-02-26 20:56:56 UTC",
 :updated_at => "2012-02-26 20:56:56 UTC" } ) }
end

