Fabricator(:item, :class_name => "SalesEngine::Item") do
  on_init { init_with( { :id => "100", :name => "Item Name",
    :description => "This is an item description",
    :unit_price => "293048",
    :merchant_id =>"50",
    :created_at => "2012-02-26 20:56:56 UTC",
    :updated_at => "2012-02-26 20:56:56 UTC" } ) }
end