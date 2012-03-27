require 'spec_helper'

describe Customer do
  let(:customer) { Customer.find_by_id 999 }

  context "Relationships" do
    describe ".random" do
      it "usually returns different things on subsequent calls" do
        customer_one = Customer.random
        10.times do
          customer_two = Customer.random
          break if customer_one != customer_two
        end

        customer_one.should_not == customer_two
      end
    end

    describe ".find_by_last_name" do
      customer = Customer.find_by_last_name "Arjun"
      customer.first_name.should == "Howell"
    end

    describe ".find_all_by_first_name" do
      customers = Customer.find_all_by_first_name "Hauck"
      customers.should have(2).customers
    end
  end

  context "Relationships" do
    describe "#invoices" do
      it "returns all of a customer's invoices" do
        customer.invoices.should have(5).invoices
      end

      it "returns invoices belonging to the customer" do
        customer.invoices.each do |invoice|
          invoice.customer_id.should == 999
        end
      end
    end

  end

  context "Business Intelligence" do
    let(:customer) { Customer.find_by_id 2 }

    describe "#transactions" do
      it "returns a list of transactions the customer has had" do
        customer.transactions.should have(7).transactions
      end
    end

    describe "#favorite_merchant" do
      it "returns the merchant where the customer has had the most transactions" do
        customer.favorite_merchant.name.should == "Altenwerth and Sons"
      end
    end
  end
end

