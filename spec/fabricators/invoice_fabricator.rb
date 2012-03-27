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
