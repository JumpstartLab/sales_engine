Fabricator(:customer, :class_name => "SalesEngine::Customer") do
  on_init { init_with( {:id => "100", :first_name => "Lemke",
    :last_name => "Eliezer", :created_at => "2012-02-26 20:56:56 UTC",
    :updated_at => "2012-02-26 20:56:56 UTC"} ) }
end