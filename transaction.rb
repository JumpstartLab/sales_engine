class Transaction
  attr_accessor :transaction_id,
                :invoice_id,
                :cc_number,
                :cc_expiration,
                :result,
                :create_date,
                :update_date

  def initialize(attributes={})
    self.transaction_id = attributes[:id].to_s
    self.invoice_id = attributes[:invoice_id].to_s
    self.cc_number = attributes[:credit_card_number].to_s
    self.cc_expiration = attributes[:credit_card_expiration_date].to_s
    self.result = attributes[:result].to_s
    self.create_date = attributes[:created_at].to_s
    self.update_date = attributes[:updated_at].to_s
  end
end