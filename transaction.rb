class Transaction
  attr_accessor :transaction_id,
                :invoice_id,
                :cc_number,
                :cc_expiration,
                :result,
                :create_date,
                :update_date

  def initialize(transaction)
    self.transaction_id = transaction[:id].to_s
    self.invoice_id = transaction[:invoice_id].to_s
    self.cc_number = transaction[:credit_card_number].to_s
    self.cc_expiration = transaction[:credit_card_expiration_date].to_s
    self.result = transaction[:result].to_s
    self.create_date = transaction[:created_at].to_s
    self.update_date = transaction[:updated_at].to_s
  end
end