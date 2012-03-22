require './spec/spec_helper'

describe Customer do
  let(:se) { Database.instance}
  let(:customer_1) { Customer.new({ :id => 1 }) }
  let(:customer_2) { Customer.new({ :id => 2 }) }

  before(:each) do
    se.clear_all_data
    se.add_to_list(customer_1)
    se.add_to_list(customer_2)
  end

  describe ".random" do
    let(:customer_3) { Customer.new({ :id => 3 }) }
  
    before(:each) do
      se.add_to_list(customer_3)
    end

    context "when customers exist in the datastore" do
      it "returns a random Customer record" do
        se.customers.include?(Customer.random).should be_true
      end
    end

    context "when there are no customers in the datastore" do
      it "returns nil" do
        se.clear_all_data
        Customer.random.should be_nil
      end
    end
  end

  describe ".find_by_id" do
    context "when customers exist in the datastore" do
      it "returns the correct customer record that matches the id" do
        Customer.find_by_id(2).should == customer_2
      end

      it "returns nothing if no customer records match the id" do
        Customer.find_by_id(100).should be_nil
      end
    end

    context "when there are no customers in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        Customer.find_by_id(1).should be_nil
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
        Customer.find_by_first_name('Beth').should == customer_2
      end

      it "returns nothing if no customer records match the first name" do
        Customer.find_by_first_name('conan').should be_nil
      end
    end

    context "when there are no customers in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        Customer.find_by_first_name('beth').should be_nil
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
        Customer.find_by_last_name('lewis').should == customer_2
      end

      it "returns nothing if no customer records match the last name" do
        Customer.find_by_last_name('Rimmer').should be_nil
      end
    end

    context "when there are no customers in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        Customer.find_by_last_name('Smith').should be_nil
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
        Customer.find_by_created_at("01/11/2012 13:00").should == customer_2
      end

      it "returns nothing if no customer records match the created_at time" do
        Customer.find_by_created_at("01/11/1979 10:00").should be_nil
      end
    end

    context "when there are no customers in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        Customer.find_by_created_at("01/11/2012 13:00").should be_nil
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
        Customer.find_by_updated_at("01/11/2012 13:00").should == customer_2
      end

      it "returns nothing if no customer records match the updated_at time" do
        Customer.find_by_updated_at("01/11/1979 10:00").should be_nil
      end
    end

    context "when there are no customers in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        Customer.find_by_updated_at("01/11/2012 13:00").should be_nil
      end
    end
  end
  
  describe ".find_all_by_id" do
    context "when customers exist in the datastore" do
      it "returns the correct customer records that matches the id" do
        Customer.find_all_by_id(2).should == [customer_2]
      end

      it "returns nothing if no customer records match the id" do
        Customer.find_all_by_id(100).should == []
      end
    end

    context "when there are no customers in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        Customer.find_all_by_id(1).should == []
      end
    end
  end

    describe ".find_all_by_first_name" do
    context "when customers exist in the datastore" do
      let(:customer_3) { Customer.new({ :id => 3 }) }

      before(:each) do
        customer_1.first_name = "Jane"
        customer_2.first_name = "Beth"
        customer_3.first_name = "jane"
        se.add_to_list(customer_3)
      end

      it "returns the correct customer records that matches the first name" do
        Customer.find_all_by_first_name("Jane").should == [customer_1, customer_3]
      end

      it "returns nothing if no customer records match the first name" do
        Customer.find_all_by_first_name('conan').should == []
      end
    end

    context "when there are no customers in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        Customer.find_all_by_first_name('beth').should == []
      end
    end
  end

    describe ".find_all_by_last_name" do
    context "when customers exist in the datastore" do
      let(:customer_3) { Customer.new({ :id => 3 }) }

      before(:each) do
        customer_1.last_name = "Wade"
        customer_2.last_name = "tebow"
        customer_3.last_name = "wade"
        se.add_to_list(customer_3)
      end

      it "returns the correct customer records that matches the name" do
        Customer.find_all_by_last_name("wade").should == [customer_1, customer_3]
      end

      it "returns nothing if no customer records match the name" do
        Customer.find_all_by_last_name('rimmer').should == []
      end
    end

    context "when there are no customers in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        Customer.find_all_by_last_name('Wade').should == []
      end
    end
  end

  describe ".find_all_by_created_at" do
    context "when customers exist in the datastore" do
      let(:customer_3) { Customer.new({ :id => 3 }) }

      before(:each) do
        customer_1.created_at = "03/01/2012 12:00"
        customer_2.created_at = "01/11/2012 13:00"
        customer_3.created_at = "01/11/2012 13:00"
        se.add_to_list(customer_3)
      end

      it "returns the correct customer records that matches the created_at time" do
        Customer.find_all_by_created_at("01/11/2012 13:00").should == [customer_2, customer_3]
      end

      it "returns nothing if no customer records match the created_at time" do
        Customer.find_all_by_created_at("01/11/1979 10:00").should == []
      end
    end

    context "when there are no customers in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        Customer.find_all_by_created_at("01/11/2012 13:00").should == []
      end
    end
  end

  describe ".find_by_updated_at" do
      context "when customer exist in the datastore" do
      let(:customer_3) { Customer.new({ :id => 3 }) }

      before(:each) do
        customer_1.updated_at = "03/01/2012 12:00"
        customer_2.updated_at = "01/11/2012 13:00"
        customer_3.updated_at = "01/11/2012 13:00"
        se.add_to_list(customer_3)
      end

      it "returns the correct customer records that matches the updated_at time" do
        Customer.find_all_by_updated_at("01/11/2012 13:00").should == [customer_2, customer_3]
      end

      it "returns nothing if no customer records match the updated_at time" do
        Customer.find_all_by_updated_at("01/11/1979 10:00").should == []
      end
    end

    context "when there are no customers in the datastore" do
      it "returns nothing" do
        se.clear_all_data
        Customer.find_all_by_updated_at("01/11/2012 13:00").should == []
      end
    end
  end

  describe "#invoices" do
    context "when customer exist in the datastore" do
      let(:invoice_1) { Invoice.new({ :id => 1, :customer_id => customer_1.id}) }
      let(:invoice_2) { Invoice.new({ :id => 2, :customer_id => customer_1.id }) }
      let(:invoice_3) { Invoice.new({ :id => 3, :customer_id => customer_2.id }) }
      let(:customer_3) { Customer.new({ :id => 3 }) }

      before(:each) do
        se.add_to_list(invoice_1)
        se.add_to_list(invoice_2)
        se.add_to_list(invoice_3)
        se.add_to_list(customer_3)
      end

      it "returns a collection of Invoice instances associated with this object" do
        customer_1.invoices.should == [invoice_1, invoice_2]
      end

      it "returns nothing if the customer has no invoices" do
        customer_3.invoices.should == []
      end      
    end
  end
end