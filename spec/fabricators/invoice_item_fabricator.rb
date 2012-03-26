Fabricator(:invoice_item, :class_name => "SalesEngine::InvoiceItem") do
  on_init { init_with( {:id => "2", :item_id => "2136", :invoice_id => "1", 
    :quantity => "6", :unit_price => "42671",
      :created_at => "2012-02-26 20:56:56 UTC",
    :updated_at => "2012-02-26 20:56:56 UTC"} ) }
end