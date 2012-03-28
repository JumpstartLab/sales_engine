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

  describe ".find_by_id()" do
    it "returns one invoice" do
      SalesEngine::Invoice.find_by_id("100").should be_a SalesEngine::Invoice
    end

    it "is associated with the id passed in" do
      result = SalesEngine::Invoice.find_by_id("100")
      result.id.should == "100"
    end
  end

  describe ".find_by_customer_id()" do
    it "returns one invoice" do
      SalesEngine::Invoice.find_by_customer_id("100").should be_a SalesEngine::Invoice
    end

    it "is associated with the customer_id passed in" do
      result = SalesEngine::Invoice.find_by_customer_id("100")
      result.customer_id.should == "100"
    end
  end

  describe ".find_by_merchant_id()" do
    it "returns one merchant" do
      SalesEngine::Invoice.find_by_merchant_id("100").should be_a SalesEngine::Invoice
    end

    it "is associated with the merchant_id passed in" do
      result = SalesEngine::Invoice.find_by_merchant_id("100")
      result.merchant_id.should == "100"
    end
  end

  describe ".find_by_status()" do
    it "returns one invoices" do
      SalesEngine::Invoice.find_by_status("shipped").should be_a SalesEngine::Invoice
    end

    it "is associated with the status passed in" do
      result = SalesEngine::Invoice.find_by_status("shipped")
      result.status.should == "shipped"
    end
  end

  describe ".find_by_created_at()" do
    it "returns one invoices" do
      SalesEngine::Invoice.find_by_created_at("2012-02-18 21:56:57 UTC").should be_a SalesEngine::Invoice
    end

    it "is associated with the created_at passed in" do
      result = SalesEngine::Invoice.find_by_created_at("2012-02-18 21:56:57 UTC")
      result.created_at.should == "2012-02-18 21:56:57 UTC"
    end
  end

  describe ".find_by_updated_at()" do
    it "returns one invoice" do
      SalesEngine::Invoice.find_by_updated_at("2012-02-26 20:56:57 UTC").should be_a SalesEngine::Invoice
    end

    it "is associated with the updated_at passed in" do
      result = SalesEngine::Invoice.find_by_updated_at("2012-02-26 20:56:57 UTC")
      result.updated_at.should == "2012-02-26 20:56:57 UTC"
    end
  end

end

