Fabricator(:merchant, :class_name => 'SalesEngine::Merchant') do
  on_init { 
    init_with(
      :id => (1..10).to_a.sample, 
      :name => Faker::Company.name
    ) 
  }
end

Fabricator(:customer, :class_name => 'SalesEngine::Customer') do
  on_init { 
    init_with(
      :id => (1..10).to_a.sample,
      :first_name => Faker::Name.first_name, 
      :last_name => Faker::Name.last_name
    )
  }
end

Fabricator(:item, :class_name => 'SalesEngine::Item') do
  on_init { 
    init_with(
      :id => (1..10).to_a.sample,
      :name => Faker::Lorem.words(1).join.capitalize,
      :description => Faker::Lorem.paragraph,
      :unit_price => (1..100000).to_a.sample,
      :merchant => Fabricate(:merchant)
    )
  }
end

Fabricator(:invoice, :class_name => 'SalesEngine::Invoice') do
  on_init {
    init_with(
      :id => (1..10).to_a.sample,
      :customer => Fabricate(:customer),
      :merchant => Fabricate(:merchant),
      :status => Faker::Lorem.words(1).join
    )
  }
end

Fabricator(:invoice_item, :class_name => 'SalesEngine::InvoiceItem') do
  on_init {
    init_with(
      :id => (1..10).to_a.sample,
      :item => Fabricate(:item),
      :invoice => Fabricate(:invoice),
      :quantity => (1..100).to_a.sample,
      :unit_price => (1..100000).to_a.sample
    )
  }
end

Fabricator(:transaction, :class_name => 'SalesEngine::Transaction') do
  on_init {
    init_with(
      :id => (1..10).to_a.sample,
      :invoice => Fabricate(:invoice),
      :credit_card_number => rand(10**16),
      :credit_card_expiration => Date.today + 1,
      :result => ['success','failure'].sample
    )
  }
end
