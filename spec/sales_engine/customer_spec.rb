require 'spec_helper'

describe SalesEngine::Customer do
  let(:se) { SalesEngine::Database.instance}
  let(:customer_1) { Fabricate(:customer) }
  let(:customer_2) { Fabricate(:customer) }
  let(:customer_3) { Fabricate(:customer) }
  let(:merchant_1) { Fabricate(:merchant) }
  let(:merchant_2) { Fabricate(:merchant) }
  let(:merchant_3) { Fabricate(:merchant) }
  let(:invoice_1) { Fabricate(:invoice, :customer_id => customer_1.id, :merchant_id => merchant_1.id) }
  let(:invoice_2) { Fabricate(:invoice, :customer_id => customer_1.id, :merchant_id => merchant_1.id) }
  let(:invoice_3) { Fabricate(:invoice, :customer_id => customer_2.id, :merchant_id => merchant_2.id) }
  let(:transaction_1) { Fabricate(:transaction, :invoice_id => invoice_1.id) }
  let(:transaction_2) { Fabricate(:transaction, :invoice_id => invoice_2.id) }
  let(:transaction_3) { Fabricate(:transaction, :invoice_id => invoice_1.id) }
  let(:transaction_4) { Fabricate(:transaction, :invoice_id => invoice_3.id) }


  before(:each) do
    se.clear_all_data
    se.add_to_list(customer_1)
    se.add_to_list(customer_2)
    se.add_to_list(customer_3)
    se.add_to_list(merchant_1)
    se.add_to_list(merchant_2)
    se.add_to_list(merchant_3)    
    se.add_to_list(invoice_1)
    se.add_to_list(invoice_2)
    se.add_to_list(invoice_3)
    se.add_to_list(transaction_1)
    se.add_to_list(transaction_2)
    se.add_to_list(transaction_3)
    se.add_to_list(transaction_4)
  end

  describe ".random" do
    context "when customers exist in the datastore" do
      it "returns a random Customer record" do
        se.customers.include?(SalesEngine::Customer.random).should be_true
      end
    end

    context "when there are no customers in the datastore" do
      it "returns nil" do
        se.clear_all_data
        SalesEngine::Customer.random.should be_nil
      end
    end
  end

  describe ".find_by_id" do
    context "when customers exist in the datastore" do
      it "returns the correct customer record that matches the id" do
        SalesEngine::Customer.find_by_id(customer_2.id).should == customer_2
      end

      it "returns nothing if no customer records match the id" do
        SalesEngine::Customer.find_by_id(10000).should be_nil
      end
    end

    context "when there are no customers in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        SalesEngine::Customer.find_by_id(customer_1.id).should be_nil
      end
    end
  end
  
  describe ".find_by_first_name" do
    context "when customers exist in the datastore" do
      before(:each) do
        customer_1.first_name = "Jane"
        customer_2.first_name = "beth"
      end

      it "returns the correct customer record that matches the first name" do
        SalesEngine::Customer.find_by_first_name('Beth').should == customer_2
      end

      it "returns nothing if no customer records match the first name" do
        SalesEngine::Customer.find_by_first_name('conan').should be_nil
      end
    end

    context "when there are no customers in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        SalesEngine::Customer.find_by_first_name('beth').should be_nil
      end
    end
  end

  describe ".find_by_last_name" do
    context "when customers exist in the datastore" do
      before(:each) do
        customer_1.last_name = "Smith"
        customer_2.last_name = "Lewis"
      end

      it "returns the correct customer record that matches the last name" do
        SalesEngine::Customer.find_by_last_name('lewis').should == customer_2
      end

      it "returns nothing if no customer records match the last name" do
        SalesEngine::Customer.find_by_last_name('Rimmer').should be_nil
      end
    end

    context "when there are no customers in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        SalesEngine::Customer.find_by_last_name('Smith').should be_nil
      end
    end
  end

  describe ".find_by_created_at" do
    context "when customers exist in the datastore" do
      before(:each) do
        customer_1.created_at = "03/01/2012 12:00"
        customer_2.created_at = "01/11/2012 13:00"
      end

      it "returns the correct customer record that matches the created_at time" do
        SalesEngine::Customer.find_by_created_at("01/11/2012 13:00").should == customer_2
      end

      it "returns nothing if no customer records match the created_at time" do
        SalesEngine::Customer.find_by_created_at("01/11/1979 10:00").should be_nil
      end
    end

    context "when there are no customers in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        SalesEngine::Customer.find_by_created_at("01/11/2012 13:00").should be_nil
      end
    end
  end
  
  describe ".find_by_updated_at" do
      context "when customers exist in the datastore" do
      before(:each) do
        customer_1.updated_at = "03/01/2012 12:00"
        customer_2.updated_at = "01/11/2012 13:00"
      end

      it "returns the correct customer record that matches the updated_at time" do
        SalesEngine::Customer.find_by_updated_at("01/11/2012 13:00").should == customer_2
      end

      it "returns nothing if no customer records match the updated_at time" do
        SalesEngine::Customer.find_by_updated_at("01/11/1979 10:00").should be_nil
      end
    end

    context "when there are no customers in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        SalesEngine::Customer.find_by_updated_at("01/11/2012 13:00").should be_nil
      end
    end
  end
  
  describe ".find_all_by_id" do
    context "when customers exist in the datastore" do
      it "returns the correct customer records that matches the id" do
        SalesEngine::Customer.find_all_by_id(customer_2.id).should == [customer_2]
      end

      it "returns nothing if no customer records match the id" do
        SalesEngine::Customer.find_all_by_id(100).should == []
      end
    end

    context "when there are no customers in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        SalesEngine::Customer.find_all_by_id(customer_1.id).should == []
      end
    end
  end

    describe ".find_all_by_first_name" do
    context "when customers exist in the datastore" do
      before(:each) do
        customer_1.first_name = "Jane"
        customer_2.first_name = "Beth"
        customer_3.first_name = "jane"
      end

      it "returns the correct customer records that matches the first name" do
        SalesEngine::Customer.find_all_by_first_name("Jane").should == [customer_1, customer_3]
      end

      it "returns nothing if no customer records match the first name" do
        SalesEngine::Customer.find_all_by_first_name('conan').should == []
      end
    end

    context "when there are no customers in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        SalesEngine::Customer.find_all_by_first_name('beth').should == []
      end
    end
  end

    describe ".find_all_by_last_name" do
    context "when customers exist in the datastore" do
      before(:each) do
        customer_1.last_name = "Wade"
        customer_2.last_name = "tebow"
        customer_3.last_name = "wade"
      end

      it "returns the correct customer records that matches the name" do
        SalesEngine::Customer.find_all_by_last_name("wade").should == [customer_1, customer_3]
      end

      it "returns nothing if no customer records match the name" do
        SalesEngine::Customer.find_all_by_last_name('rimmer').should == []
      end
    end

    context "when there are no customers in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        SalesEngine::Customer.find_all_by_last_name('Wade').should == []
      end
    end
  end

  describe ".find_all_by_created_at" do
    context "when customers exist in the datastore" do
      before(:each) do
        customer_1.created_at = "03/01/2012 12:00"
        customer_2.created_at = "01/11/2012 13:00"
        customer_3.created_at = "01/11/2012 13:00"
      end

      it "returns the correct customer records that matches the created_at time" do
        SalesEngine::Customer.find_all_by_created_at("01/11/2012 13:00").should == [customer_2, customer_3]
      end

      it "returns nothing if no customer records match the created_at time" do
        SalesEngine::Customer.find_all_by_created_at("01/11/1979 10:00").should == []
      end
    end

    context "when there are no customers in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        SalesEngine::Customer.find_all_by_created_at("01/11/2012 13:00").should == []
      end
    end
  end

  describe ".find_by_updated_at" do
      context "when customer exist in the datastore" do
      before(:each) do
        customer_1.updated_at = "03/01/2012 12:00"
        customer_2.updated_at = "01/11/2012 13:00"
        customer_3.updated_at = "01/11/2012 13:00"
      end

      it "returns the correct customer records that matches the updated_at time" do
        SalesEngine::Customer.find_all_by_updated_at("01/11/2012 13:00").should == [customer_2, customer_3]
      end

      it "returns nothing if no customer records match the updated_at time" do
        SalesEngine::Customer.find_all_by_updated_at("01/11/1979 10:00").should == []
      end
    end

    context "when there are no customers in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        SalesEngine::Customer.find_all_by_updated_at("01/11/2012 13:00").should == []
      end
    end
  end

  describe "#invoices" do
    context "when customer exist in the datastore" do
      it "returns a collection of Invoice instances associated with this object" do
        customer_1.invoices.should == [invoice_1, invoice_2]
      end

      it "returns nothing if the customer has no invoices" do
        customer_3.invoices.should == []
      end      
    end
  end

  describe "#transactions" do
    it "returns an array of Transaction instances associated with the customer" do
      customer_1.transactions.should == [transaction_1, transaction_2, transaction_3]
    end
  end

  describe "#favorite_merchant" do
    let(:invoice_4) { Fabricate(:invoice, :customer_id => customer_3.id, :merchant_id => merchant_1.id) }
    let(:invoice_5) { Fabricate(:invoice, :customer_id => customer_3.id, :merchant_id => merchant_2.id) }
    let(:invoice_6) { Fabricate(:invoice, :customer_id => customer_3.id, :merchant_id => merchant_2.id) }

    before(:each) do
      se.add_to_list(invoice_4)
      se.add_to_list(invoice_5)
      se.add_to_list(invoice_6)
    end

    it "returns an instance of Merchant where the customer has conducted the most transactions" do
      customer_3.favorite_merchant.should == merchant_2
    end
  end
end