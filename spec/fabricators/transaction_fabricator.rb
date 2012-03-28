Fabricator(:transaction, :class_name => 'SalesEngine::Transaction') do
  on_init {
    init_with(
      :id => (1..10).to_a.sample,
      :invoice_id => 1,
      :credit_card_number => rand(10**16),
      :credit_card_expiration => Date.today + 1,
      :result => ['success','failure'].sample
    )
  }
end
