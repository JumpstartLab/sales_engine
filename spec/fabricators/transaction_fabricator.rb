Fabricator(:transaction, :class_name => "SalesEngine::Transaction") do
  on_init { init_with( {:id => "2", :invoice_id => "2",
    :credit_card_number => "4177816490204479",
    :credit_card_expiration_date => "",
    :result => "success",
    :created_at => "2012-02-26 20:56:56 UTC",
    :updated_at => "2012-02-26 20:56:56 UTC" } ) }
end