require './lib/invoice_item'
require './lib/database'
require 'spec_helper'

describe InvoiceItem do
  describe ".random" do
    context "when database has invoice_items loaded" do
      before(:each) do
        @invoice_items = 10.times.collect { mock(InvoiceItem) } 
        Database.stub(:invoice_items).and_return(@invoice_items)
      end

      it "returns a random object from invoice_items array" do
        Random.stub(:rand).and_return(5)
        InvoiceItem.random.should == @invoice_items[5]
      end

      it "returns a invoice_item" do
        puts InvoiceItem.random.inspect
        InvoiceItem.random.is_a?(mock(InvoiceItem).class).should == true
      end
    end

    context "when database has no invoice_items" do
      it "returns nil" do
        InvoiceItem.random.should == nil
      end
    end
  end

  describe ".find_by" do
    let(:invoice_item) { mock(InvoiceItem) }
    let(:invoice_item2) { mock(InvoiceItem) }
    let(:invoice_item3) { mock(InvoiceItem) }
    let(:duplicate_invoice_item) { mock(InvoiceItem) }
    let(:invoice_items) { [invoice_item, invoice_item2, invoice_item3, duplicate_invoice_item] }

    before(:each) do
      invoice_item.stub(:id).and_return(1)
      invoice_item2.stub(:id).and_return(2)
      invoice_item3.stub(:id).and_return(3)
      duplicate_invoice_item.stub(:id).and_return(1)
    end

    it "calls find_by attribute" do
      Database.stub(:invoice_items).and_return(invoice_items)
      InvoiceItem.find_by_id(2).should == invoice_item2
    end
  end

  describe ".find_all_by" do
    let(:invoice_item) { mock(InvoiceItem) }
    let(:invoice_item2) { mock(InvoiceItem) }
    let(:duplicate_invoice_item) { mock(InvoiceItem) }
    let(:invoice_items) { [invoice_item, invoice_item2, duplicate_invoice_item] }

    before(:each) do
      invoice_item.stub(:id).and_return(1)
      invoice_item2.stub(:id).and_return(2)
      duplicate_invoice_item.stub(:id).and_return(1)
    end
    
    it "calls find_all_by attribute" do
      Database.stub(:invoice_items).and_return(invoice_items)
      InvoiceItem.find_all_by_id(1).should == [invoice_item, duplicate_invoice_item]
    end
  end

  describe "method missing" do
    it "invokes the normal no method error" do
      expect{InvoiceItem.foo}.should raise_error
    end
  end

  describe "respond to" do
    let(:invoice_item) { InvoiceItem.new(1, 1, 1, 1, 0, Date.today, Date.today)}
    it "returns true for find_by" do
      invoice_item.respond_to?("find_by_id").should == true
    end
    it "returns true for find_all_by" do
      invoice_item.respond_to?("find_all_by_id").should == true
    end
    it "returns false for a method that doesn't exist" do
      invoice_item.respond_to?("foo").should == false
    end
  end
end