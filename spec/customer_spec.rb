require 'spec_helper'

describe SalesEngine::Customer do
  let(:valid_customer) { Fabricate(:customer) }

  it "assigns a customer name when given as an attribute" do
    first, last = 'Jackie', 'Chan'
    customer = SalesEngine::Customer.new :id => 1, :first_name => first, :last_name => last
    customer.first_name.should == first
  end

  context "first_name" do
    it "exists" do
      expect do
        SalesEngine::Customer.new :id => 1, :last_name => 'Chan'
      end.to raise_error ArgumentError
    end

    it "isn't blank" do
      valid_customer.first_name.should_not be_empty
    end
  end

  context "last_name" do
    it "exists" do
      expect do
        SalesEngine::Customer.new :id => 1, :first_name => 'Jackie'
      end.to raise_error ArgumentError
    end

    it "isn't blank" do
      valid_customer.last_name.should_not be_empty
    end

    it "can be blank" do
      SalesEngine::Customer.new :id => 1, :first_name => 'Jackie', :last_name => ''
    end
  end

  context "can't be created if" do
    it "first_name is blank" do
      expect do
        SalesEngine::Customer.new :id => 1, :first_name => '', :last_name => 'Chan'
      end.to raise_error ArgumentError
    end
  end

  # harness specs

  let(:customer) { SalesEngine::Customer.find_by_id 999 }

  context "Relationships" do
    describe ".random" do
      it "usually returns different things on subsequent calls" do
        customer_one = SalesEngine::Customer.random
        customer_two = SalesEngine::Customer.random

        10.times do
          break if customer_one.id != customer_two.id
          customer_two = SalesEngine::Customer.random
        end

        customer_one.id.should_not == customer_two.id
      end
    end

    describe ".find_by_last_name" do
      it "finds a record" do
        customer = SalesEngine::Customer.find_by_last_name "Ullrich"
        %w(Ramon Brice Annabell).should include(customer.first_name)
      end
    end

    describe ".find_all_by_first_name" do
      it "can find multiple records" do
        customers = SalesEngine::Customer.find_all_by_first_name "Sasha"
        customers.should have(2).customers
      end
    end
  end

  context "Relationships" do
    describe "#invoices" do
      it "returns all of a customer's invoices" do
        customer.invoices.should have(7).invoices
      end

      it "returns invoices belonging to the customer" do
        customer.invoices.each do |invoice|
          invoice.customer_id.should == 999
        end
      end
    end

  end

  context "Business Intelligence" do
    let(:customer) { SalesEngine::Customer.find_by_id 2 }

    describe "#transactions" do
      it "returns a list of transactions the customer has had" do
        customer.transactions.should have(1).transaction
      end
    end

    describe "#favorite_merchant" do
      it "returns the merchant where the customer has had the most transactions" do
        customer.favorite_merchant.name.should == "Shields, Hirthe and Smith"
      end
    end
  end
end
