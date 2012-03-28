require 'spec_helper'

module SalesEngine
describe Merchant do
  describe "#invoices" do
    let(:invoice1) { double("invoice", :merchant_id => 1,
                                       :created_at => Date.parse("2012-02-26 20:56:56 UTC")) }
    let(:invoice2) { double("invoice", :merchant_id => 2,
                                       :created_at => Date.parse("2012-02-28 20:56:56 UTC")) }
    let(:invoice3) { double("invoice", :merchant_id => 1) }
    let(:merchant) { Fabricate(:merchant, :id => 2) }

    context "when date is specified" do
      it "returns the invoices for that date" do
        Invoice.stub(:for_merchant_and_date).and_return([invoice2])
        merchant.invoices(Date.parse("2012-02-28 20:56:56 UTC")).should == [invoice2]
      end
    end
    context "when date is not specified" do
      context "when merchant has one invoice" do
        it "returns an array containing the single invoice" do
          Invoice.stub(:for_merchant).and_return([invoice2])
          merchant.invoices.should == [invoice2]
        end
      end

      context "when merchant has multiple invoices" do
        it "returns all invoices" do
          Invoice.stub(:for_merchant).and_return([invoice1, invoice3])
          merchant.invoices.should == [invoice1, invoice3]
        end
      end

      context "when merchant has no invoices" do
        it "returns an empty array" do
          Invoice.stub(:for_merchant).and_return([])
          merchant.invoices.should == []
        end
      end
    end
  end


  describe "#items" do
    let(:item1) { mock(Item) }
    let(:item2) { mock(Item) }
    let(:item3) { mock(Item) }

    before(:each) do
      item1.stub(:merchant_id).and_return(1)
      item2.stub(:merchant_id).and_return(2)
      item3.stub(:merchant_id).and_return(1)

      items = [item1, item2, item3]
      Item.stub(:items).and_return(items)
    end


    context "when merchant has one item" do
      it "returns an array containing the single item" do
        merchant = Fabricate(:merchant, :id => 2)
        merchant.items.should == [item2]
      end
    end

    context "when merchant has multiple items" do
      it "returns all items" do
        merchant = Fabricate(:merchant, :id => 1)
        merchant.items.should == [item1, item3]
      end
    end

    context "when merchant has no items" do
      it "returns an empty array" do
        merchant = Fabricate(:merchant, :id => 3)
        merchant.items.should == []
      end
    end
  end

  describe "#paid_invoice_items" do
    let(:invoices) { mock(Array) }
    let(:invoice) { double("invoice", :created_at => DateTime.parse("2012-02-26 20:56:56 UTC")) }
    let(:invoice2) { double("invoice", :created_at => DateTime.parse("2012-02-28 20:56:56 UTC")) }
    let(:invoice_item) { double("invoice_item") } 
    let(:invoice_item2) { double("invoice_item") }
    let(:other_invoice_item) { double("invoice_item") } 
    let(:merchant) { merchant = Fabricate(:merchant, :id => 3) }

    before(:each) do
      invoice.stub(:invoice_items).and_return([invoice_item, other_invoice_item])
      invoice2.stub(:invoice_items).and_return([invoice_item2])
    end
    context "when date is passed" do
      it "returns the paid invoice items for that date" do
        date = Date.parse "26 Feb 2012"
        merchant.stub(:invoices).with(date).and_return([invoice])
        InvoiceItem.stub(:successful_for_merchant_and_date).and_return([invoice_item, other_invoice_item])
        merchant.paid_invoice_items(date).should == [invoice_item, other_invoice_item]
      end
    end

    context "when date is not passed" do
      it "delgates to the Database#invoice_items_by_merchant" do
          InvoiceItem.stub(:successful_for_merchant).with(3).and_return([invoice_item])
          merchant.paid_invoice_items.should == [invoice_item]
      end
    end
  end

  describe "#customers" do
    let(:merchant) { merchant = Fabricate(:merchant, :id => 3) }

    it "delgates to the Database#customers_by_merchant" do
        Customer.should_receive(:for_merchant).with(3)
        merchant.customers
    end
  end

  describe "#customers_with_pending_invoices" do
    let(:merchant) { merchant = Fabricate(:merchant) }
    let(:customer1) { double("customer") }
    let(:customer2) { double("customer") }
    let(:customer3) { double("customer") }
    let(:customer4) { double("customer") }

    before(:each) do
      customer1.stub(:has_pending_invoice?).and_return(true)
      customer2.stub(:has_pending_invoice?).and_return(true) 
      customer3.stub(:has_pending_invoice?).and_return(false)
      customer4.stub(:has_pending_invoice?).and_return(false)     
    end
    context "the merchant has customers" do
      context "there are customers with pending invoices" do
        it "returns the customers with pending transactions" do
          merchant.stub(:customers).and_return([customer1, customer2, customer3, customer4])
          merchant.customers_with_pending_invoices.should == [customer1, customer2]
        end
      end
      context "there are no customers with pending invoices" do
        it "returns an empty array" do
          merchant.stub(:customers).and_return([customer3, customer4])
          merchant.customers_with_pending_invoices.should == []         
        end
      end
    end
    context "the merchant has no customers" do
      it "returns an empty array" do
        merchant.stub(:customers).and_return([])
        merchant.customers_with_pending_invoices.should == []
      end
    end
  end

  describe "#revenue" do
    let(:invoice_item) { mock(InvoiceItem)}
    let(:invoice_item2) { mock(InvoiceItem)}
    let(:other_invoice_item) { mock(InvoiceItem)}
    let(:merchant) { Fabricate(:merchant, :id => 3) }

    before(:each) do
      invoice_item.stub(:unit_price).and_return(BigDecimal.new("100"))
      invoice_item.stub(:quantity).and_return(BigDecimal.new("1"))
      invoice_item2.stub(:unit_price).and_return(BigDecimal.new("200"))
      invoice_item2.stub(:quantity).and_return(BigDecimal.new("2"))
      other_invoice_item.stub(:unit_price).and_return(BigDecimal.new("300"))
      other_invoice_item.stub(:quantity).and_return(BigDecimal.new("3"))
    end

    context "when there are invoice_items" do
      it "returns total revenue for merchant" do
        merchant.stub({:paid_invoice_items => [invoice_item, invoice_item2, other_invoice_item]})
        merchant.revenue.should == 14.00 
      end
    end
    context "when there are no invoice items" do
      it "returns 0" do
        merchant.stub({:paid_invoice_items => []})
        merchant.revenue.should == 0
      end
    end
  end

  describe ".most_revenue" do
    let(:merchant) { double("merchant", :revenue => 10) }
    let(:merchant2) { double("merchant", :revenue => 20) }
    let(:merchant3) { double("merchant", :revenue => 30) }
    let(:merchant4) { double("merchant", :revenue => 40) }

    context "when number of merchants is greater than X" do
      it "returns an array of merchants with the most revenue" do
        Merchant.stub(:merchants).and_return([merchant, merchant2, merchant3, merchant4])
        Merchant.most_revenue(2).should == [merchant4, merchant3]
      end
    end
    context "when number of merchants is less than X" do
      it "returns an array of all merchants" do
        Merchant.stub(:merchants).and_return([merchant, merchant2])
        Merchant.most_revenue(3).should == [merchant2, merchant]
      end
    end
    context "when there is only one merchant" do
      it "returns an array with one merchant" do
        Merchant.stub(:merchants).and_return([merchant])
        Merchant.most_revenue(1).should == [merchant]
      end
    end
    context "when there are no merchants" do
      it "returns an empty array" do
        Merchant.stub(:merchants).and_return([])
        Merchant.most_revenue(3).should == []
      end
    end 
  end

  describe "#revenue(date)" do
    let(:invoice) {double("invoice", :id => 1)}
    let(:invoice2) {double("invoice", :id => 2)}
    let(:invoice_item) { double("invoice", :unit_price => BigDecimal.new("100"), 
                                           :quantity => BigDecimal.new("1"),
                                           :invoice_id => 1)}
    let(:invoice_item2) { double("invoice", :unit_price => BigDecimal.new("200"), 
                                            :quantity => BigDecimal.new("2"),
                                            :invoice_id => 1)}
    let(:other_invoice_item) { double("invoice", :unit_price => BigDecimal.new("300"), 
                                                 :quantity => BigDecimal.new("3"),
                                                 :invoice_id => 2)}
    let(:merchant) { merchant = Fabricate(:merchant, :id => 3) }
    let(:date) { "2012-02-26 20:56:56 UTC" }
    before(:each) do
      merchant.stub(:paid_invoice_items).and_return([invoice_item, invoice_item2, other_invoice_item])
      invoice_item.stub(:created_at).and_return
    end

    context "invoice items exist for the provided date" do
      it "returns the total revenue for that date" do
        merchant.stub(:paid_invoice_items).with(date).and_return([invoice_item2, other_invoice_item])
        merchant.revenue(date).should == BigDecimal.new("13.00")
      end
    end
    context "no invoice items exist for the provided date" do
      it "returns zero" do
        merchant.stub(:paid_invoice_items).with(date).and_return([])
        merchant.revenue(date).should == 0
      end
    end
  end
end
end
