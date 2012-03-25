require 'spec_helper.rb'

describe SalesEngine::Customer do

  let(:customer_zero) { SalesEngine::Customer.new(:id => "0") }
  let(:customer_one) { SalesEngine::Customer.new(:id => "1") }
  let(:invoice_one) { SalesEngine::Invoice.new(:id => "1", :customer_id => "0") }
  let(:invoice_two) { SalesEngine::Invoice.new(:id => "2", :customer_id => "2") }
  let(:invoice_three) { SalesEngine::Invoice.new(:id => "3", :customer_id => "0") }

  describe "#invoices" do
    it "returns an array of invoices" do
      SalesEngine::Database.instance.invoice_list = [ invoice_one, invoice_two, invoice_three ]
      customer_zero.invoices.should == [ invoice_one, invoice_three ]
    end

    context "when customer has no invoices" do
      it "returns an empty array" do
        customer_one.invoices.should be_empty
      end
    end
  end

  # describe ".random" do
  #   it "returns a random instance of customer in customer_list" do
  #   end

  #   context "returns nil when there are no customers" do
  #   end
  # end

  # describe ".find_by_id" do
  #   it "returns a single customer whose id matches param" do
  #   end

  #   context "returns nil when there are no customers" do
  #   end
  # end

  # describe ".find_by_first_name" do
  #   it "returns a single customer whose first_name matches param" do
  #   end

  #   context "returns nil when there are no customers" do
  #   end
  # end

  # describe ".find_by_last_name" do
  #   it "returns a single customer whose last_name matches param" do
  #   end

  #   context "returns nil when there are no customers" do
  #   end
  # end

  # describe ".find_by_created_at" do
  #   it "returns a single customer whose created_at matches param" do
  #   end

  #   context "returns nil when there are no customers" do
  #   end
  # end

  # describe ".find_by_updated_at" do
  #   it "returns a single customer whose updated_at matches param" do
  #   end

  #   context "returns nil when there are no customers" do
  #   end
  # end
end