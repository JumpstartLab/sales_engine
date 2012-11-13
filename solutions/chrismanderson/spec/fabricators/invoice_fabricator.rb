Fabricator(:invoice, :class_name => "SalesEngine::Invoice") do
  on_init { init_with( {  :id => "1",
                          :customer_id => "1",
                          :merchant_id => "92",
                          :status => "shipped",
                          :created_at => "2012-02-14 20:56:56 UTC",
                          :updated_at => "2012-02-26 20:56:56 UTC" } ) }
end