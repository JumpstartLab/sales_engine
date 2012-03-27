require 'spec_helper'

describe SalesEngine::Invoice do

  let(:test_invoice){ Fabricate(:invoice) }

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

      # it "adds the total of invoice items" do
      #   test_ii_1.quantity = "10"
      #   test_ii_2.quantity = "10"
      #   test_ii_1.unit_price = "2"
      #   test_ii_2.unit_price = "2"


      #   test_ii_1.invoice_id = "10001"
      #   test_ii_2.invoice_id = "10001"
      #   puts "test_ii_2 is #{test_ii_2.inspect}"
      #   puts "test_ii_2 is #{test_ii_2.total}"
      #   test_invoice.id = "10001"
      #   test_invoice.total.should == 20
      # end
    end
  end

end

