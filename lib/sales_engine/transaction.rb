module SalesEngine
  class Transaction < Record
    attr_accessor :invoice_id, :credit_card_number,
                  :credit_card_expiration_date, :result

    def initialize(attributes ={})
      super
      self.invoice_id = attributes[:invoice_id].to_i
      self.credit_card_number = attributes[:credit_card_number]
      self.credit_card_expiration_date = attributes[
        :credit_card_expiration_date]
      self.result = attributes[:result]
    end

    def successful?
      result.downcase == "success"
    end

    def self.random
      DATABASE.get_random_record("transactions")
    end

    def invoice
      DATABASE.find_by("invoices", "id", self.invoice_id)
    end

    def self.find_by_invoice_id(id)
      DATABASE.find_by("transactions", "invoice_id", id)
    end

    def self.find_by_id(id)
      DATABASE.find_by("transactions", "id", id)
    end

    def self.find_by_credit_card_number(credit_card_number)
      DATABASE.find_by("transactions", "credit_card_number",
        credit_card_number)
    end

    def self.find_by_credit_card_expiration_date(credit_card_expiration_date)
      DATABASE.find_by("transactions", "credit_card_expiration_date",
        credit_card_expiration_date)
    end

    def self.find_by_result(result)
      DATABASE.find_by("transactions", "result", result)
    end

    def self.find_all_by_id(id)
      DATABASE.find_all_by("transactions", "id", id)
    end

    def self.find_all_by_invoice_id(invoice_id)
      DATABASE.find_all_by("transactions", "invoice_id", invoice_id)
    end

    def self.find_all_by_credit_card_number(credit_card_number)
      DATABASE.find_all_by("transactions", "credit_card_number",
        credit_card_number)
    end

    def self.find_all_by_credit_card_expiration_date(expiration_date)
      DATABASE.find_all_by("transactions", "credit_card_expiration_date",
        expiration_date)
    end

    def self.find_all_by_result(result)
      DATABASE.find_all_by("transactions", "result", result)
    end
  end
end