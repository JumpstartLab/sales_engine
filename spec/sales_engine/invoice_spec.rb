require 'spec_helper'

describe SalesEngine::Invoice do

  let(:test_invoice){ Fabricate(:invoice) }

  describe "#customer=" do
    it "sets the customer" do
      customer = Fabricate(:customer)
      test_invoice.customer = customer
      test_invoice.customer.should == customer
    end
  end 

  describe "#merchant=" do
    it "sets the merchant" do
      merchant = Fabricate(:merchant)
      test_invoice.merchant = merchant
      test_invoice.merchant.should == merchant
    end

    it "sets the merchant_id" do
      merchant = Fabricate(:merchant)
      test_invoice.merchant = merchant
      test_invoice.merchant_id.should == merchant.id
    end
  end

  describe "#transactions" do
    context "returns a collection of associated transactions" do
      it "contains things which are only transactions" do
        test_invoice.transactions.all?{|i| i.is_a? SalesEngine::Transaction}.should == true
      end

      it "contains only transactions related to this invoice" do
        test_invoice.transactions.all? {|i| 
          i.invoice_id == test_invoice.id}.should == true
      end
    end
  end

  describe "#invoice_items" do
    context "returns a collection of invoice items" do

      it "contains things which are only invoice items" do
        test_invoice.invoice_items.all?{|i| i.is_a? SalesEngine::InvoiceItem}.should == true
      end

      it "contains invoice items associated with only this item" do
        test_invoice.invoice_items.all? {|i|
          i.invoice_id == test_invoice.id}.should == true
      end
    end
  end

  describe "#customer" do
    context "returns a related customer" do
      it "is a customer" do
        test_invoice.customer.is_a?(SalesEngine::Customer).should == true
      end

      it "returns an associated customer" do 
        test_invoice.customer.id.should == test_invoice.customer_id
      end
    end
  end

  describe "#items" do
    context "returns a collection of related items" do
      it "contains things which are only items" do
        test_invoice.items.all?{|i| i.is_a? SalesEngine::Item}.should == true
      end

      it "contains only related items"
        # test_invoice.items.all?{|i|
        #   test_invoice.invoice_item}
      
    end
  end

  describe ".random" do
    it "returns one invoice" do
      SalesEngine::Invoice.random.should be_a SalesEngine::Invoice
    end
  end

  describe "#total" do
    let(:test_ii_1) {Fabricate(:invoice_item)}
    let(:test_ii_2) {Fabricate(:invoice_item)}

    context "for selected invoice" do
      it "gets invoice_items" do
        test_invoice.should_receive(:invoice_items).and_return([test_ii_1])
        test_invoice.total
      end

      it "returns a number" do
        test_invoice.total.should be_a Fixnum
      end
    end
  end

  test_invoices = [ Fabricate(:invoice,
                              :id => "1",
                              :customer_id => "2",
                              :merchant_id => "92",
                              :status => "shipped",
                              :created_at => "3/31/1985",
                              :updated_at => "3/31/1985"),
                    Fabricate(:invoice,
                              :id => "2",
                              :customer_id => "3",
                              :merchant_id => "93",
                              :status => "shipped",
                              :created_at => "3/31/1985",
                              :updated_at => "3/31/1985"),
                    Fabricate(:invoice,
                              :id => "3",
                              :customer_id => "4",
                              :merchant_id => "94",
                              :status => "shipped",
                              :created_at => "3/31/1985",
                              :updated_at => "3/31/1985") ]

  describe ".find_by_id()" do
    it "returns one invoice" do
      SalesEngine::Database.instance.stub(:invoices).and_return(test_invoices)
      SalesEngine::Invoice.find_by_id("1").should be_a SalesEngine::Invoice
    end

    it "is associated with the id passed in" do
      SalesEngine::Database.instance.stub(:invoices).and_return(test_invoices)
      result = SalesEngine::Invoice.find_by_id("1")
      result.id.should == "1"
    end
  end

  describe ".find_by_customer_id()" do
    it "returns one invoice" do
      SalesEngine::Database.instance.stub(:invoices).and_return(test_invoices)
      SalesEngine::Invoice.find_by_customer_id("4").should be_a SalesEngine::Invoice
    end

    it "is associated with the customer_id passed in" do
      SalesEngine::Database.instance.stub(:invoices).and_return(test_invoices)
      result = SalesEngine::Invoice.find_by_customer_id("4")
      result.customer_id.should == "4"
    end
  end

  describe ".find_by_merchant_id()" do
    it "returns one merchant" do
      SalesEngine::Database.instance.stub(:invoices).and_return(test_invoices)
      SalesEngine::Invoice.find_by_merchant_id("93").should be_a SalesEngine::Invoice
    end

    it "is associated with the merchant_id passed in" do
      SalesEngine::Database.instance.stub(:invoices).and_return(test_invoices)
      result = SalesEngine::Invoice.find_by_merchant_id("93")
      result.merchant_id.should == "93"
    end
  end

  describe ".find_by_status()" do
    it "returns one invoices" do
      SalesEngine::Database.instance.stub(:invoices).and_return(test_invoices)
      SalesEngine::Invoice.find_by_status("shipped").should be_a SalesEngine::Invoice
    end

    it "is associated with the status passed in" do
      SalesEngine::Database.instance.stub(:invoices).and_return(test_invoices)
      result = SalesEngine::Invoice.find_by_status("shipped")
      result.status.should == "shipped"
    end
  end

  describe ".find_by_created_at()" do
    it "returns one invoice" do
      SalesEngine::Database.instance.stub(:invoices).and_return(test_invoices)
      SalesEngine::Invoice.find_by_created_at("3/31/1985").should be_a SalesEngine::Invoice
    end

    it "is associated with the created_at passed in" do
      SalesEngine::Database.instance.stub(:invoices).and_return(test_invoices)
      result = SalesEngine::Invoice.find_by_created_at("3/31/1985")
      result.created_at.should == "3/31/1985"
    end
  end

  describe ".find_by_updated_at()" do
    it "returns one invoice" do
      SalesEngine::Database.instance.stub(:invoices).and_return(test_invoices)
      SalesEngine::Invoice.find_by_updated_at("3/31/1985").should be_a SalesEngine::Invoice
    end

    it "is associated with the updated_at passed in" do
      SalesEngine::Database.instance.stub(:invoices).and_return(test_invoices)
      result = SalesEngine::Invoice.find_by_updated_at("3/31/1985")
      result.updated_at.should == "3/31/1985"
    end
  end

  describe ".find_all_by_id()" do
    it "returns an array of invoices" do
      SalesEngine::Database.instance.stub(:invoices).and_return(test_invoices)
      SalesEngine::Invoice.find_all_by_id("1").all?{|i| i.is_a? SalesEngine::Invoice}.should == true
    end

    it "contains invoices related to the id given" do
      SalesEngine::Database.instance.stub(:invoices).and_return(test_invoices)
      results = SalesEngine::Invoice.find_all_by_id("1")
      results.sample.id.should == "1"
    end
  end

  describe ".find_all_by_created_at()" do
    it "returns an array of invoices" do
      SalesEngine::Database.instance.stub(:invoices).and_return(test_invoices)
      SalesEngine::Invoice.find_all_by_created_at("3/31/1985").all?{|i| i.is_a? SalesEngine::Invoice}.should == true
    end

    it "contains invoices related to the created_at given" do
      SalesEngine::Database.instance.stub(:invoices).and_return(test_invoices)
      results = SalesEngine::Invoice.find_all_by_created_at("3/31/1985")
      results.sample.created_at.should == "3/31/1985"
    end
  end

  describe ".find_all_by_updated_at()" do
    it "returns an array of invoices" do
      SalesEngine::Database.instance.stub(:invoices).and_return(test_invoices)
      SalesEngine::Invoice.find_all_by_updated_at("3/31/1985").all?{|i| i.is_a? SalesEngine::Invoice}.should == true
    end

    it "contains invoices related to the date given" do
      SalesEngine::Database.instance.stub(:invoices).and_return(test_invoices)
      results = SalesEngine::Invoice.find_all_by_updated_at("3/31/1985")
      results.sample.updated_at.should == "3/31/1985"
    end
  end

  describe ".find_all_by_merchant_id()" do
    it "returns an array of invoices" do
      SalesEngine::Database.instance.stub(:invoices).and_return(test_invoices)
      SalesEngine::Invoice.find_all_by_merchant_id("93").all?{|i| i.is_a? SalesEngine::Invoice}.should == true
    end

    it "contains invoices related to the merchant_id given" do
      SalesEngine::Database.instance.stub(:invoices).and_return(test_invoices)
      results = SalesEngine::Invoice.find_all_by_merchant_id("93")
      results.sample.merchant_id.should == "93"
    end
  end

  describe ".find_all_by_customer_id()" do
    it "returns an array of invoices" do
      SalesEngine::Database.instance.stub(:invoices).and_return(test_invoices)
      SalesEngine::Invoice.find_all_by_customer_id("3").all?{|i| i.is_a? SalesEngine::Invoice}.should == true
    end

    it "contains invoices related to the customer_id given" do
      SalesEngine::Database.instance.stub(:invoices).and_return(test_invoices)
      results = SalesEngine::Invoice.find_all_by_customer_id("3")
      results.sample.customer_id.should == "3"
    end
  end

  describe ".find_all_by_status()" do
    it "returns an array of invoices" do
      SalesEngine::Database.instance.stub(:invoices).and_return(test_invoices)
      SalesEngine::Invoice.find_all_by_status("shipped").all?{|i| i.is_a? SalesEngine::Invoice}.should == true
    end

    it "contains invoices related to the status given" do
      SalesEngine::Database.instance.stub(:invoices).and_return(test_invoices)
      results = SalesEngine::Invoice.find_all_by_status("shipped")
      results.sample.status.should == "shipped"
    end
  end

  describe ".create" do
    merch_1 = Fabricate(:merchant, :name => "Giles", :id => 5000)
    cust_1 = Fabricate(:customer, :first_name => "Buffy", :id => 5001)

    item_1 = Fabricate(:item)
    item_2 = Fabricate(:item)
    item_3 = Fabricate(:item)

    attr = {}
    attr[:customer] = cust_1
    attr[:merchant] = merch_1
    attr[:status] = "shipped"
    attr[:items] = [item_1, item_2, item_3]

    it "returns a new invoice" do
      SalesEngine::Invoice.create(attr).should be_a SalesEngine::Invoice
    end

    it "adds a new customer to the database" do
      SalesEngine::Invoice.create(attr)
      SalesEngine::Customer.find_by_first_name("Buffy").should be_a SalesEngine::Customer
    end

    it "adds a new merchant to the database" do
      SalesEngine::Invoice.create(attr)
      SalesEngine::Merchant.find_by_name("Giles").should be_a SalesEngine::Merchant
    end
  end
end

