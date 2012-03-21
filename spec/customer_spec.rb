require './spec/spec_helper.rb'
require "./merchant"
require "./customer"
require "./transaction"
require "./invoice"
require "./item"
require "./invoice_item"
require "rspec"
require "date"

describe Customer do
  describe 'find_by_#{attribute}(attribute) methods' do
    Customer::ATTRIBUTES.each do |attribute|
      context ".find_by_#{attribute}" do
        it "should have generated the class method" do
          Customer.should be_respond_to("find_by_#{attribute}")
        end
      end
    end
  end

  describe 'test accessors' do
    let(:test_customer) { Customer.new }
    Customer::ATTRIBUTES.each do |attribute|
      context "responds to attr_accessors" do
        it "generates the reader" do
          test_customer.should be_respond_to("#{attribute}")
        end
        it "generates the writer" do
          test_customer.should be_respond_to("#{attribute}=")
        end
      end
    end
  end

  let(:test_customer) do
    attr_hash = {first_name: "Horatio", last_name: "Casimir", id:7, created_at:Date.today-1, updated_at: Date.today }
    Customer.new(attr_hash)
  end
  context "#invoices" do
    it "returns an array" do
      invoices = test_customer.invoices
      invoices.should be_is_a(Array)
    end

    it "returns an array of Invoices" do
      invoices = test_customer.invoices
      invoices.each do |invoice|
        invoice.should be_is_a(Invoice)
      end
    end
  end

  context "#transactions" do
    it "returns an array" do
      transactions = test_customer.transactions
      transactions.should be_is_a(Array)
    end

    it "returns an array of Transactions" do
      transactions = test_customer.transactions
      transactions.each do |invoice|
        invoice.should be_is_a(Transaction)
      end
    end
  end

  # context "#favorite_merchant" do
  #   it "returns a Merchant object" do
  #     test_customer.favorite_merchant.should be_is_a(Merchant)
  #   end
  # end

end