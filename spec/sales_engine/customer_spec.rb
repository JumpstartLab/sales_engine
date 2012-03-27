require 'spec_helper'

describe SalesEngine::Customer do

  let(:test_customer){Fabricate(:customer)}

  describe "#invoices" do
    context "returns a collection of invoices" do
      it "contains things which are only invoices" do
        test_customer.invoices.all?{|i| i.is_a? SalesEngine::Invoice}.should == true
      end

      it "contains invoices associated with only this merchant" do
        test_customer.invoices.all? {|i|
          i.customer_id == test_customer.id}.should == true
      end
    end
  end

  describe ".random" do
    it "returns one customer" do
      SalesEngine::Customer.random.should be_a SalesEngine::Customer
    end
  end

end
