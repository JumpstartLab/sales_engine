require 'spec_helper'
require './lib/invoice'
require './lib/database'

describe Invoice do
  describe ".random" do
    context "when database has invoices loaded" do
      before(:each) do
        @invoices = 10.times.collect { mock(Invoice) } 
        Database.stub(:invoices).and_return(@invoices)
      end

      it "returns a random object from invoices array" do
        Random.stub(:rand).and_return(5)
        Invoice.random.should == @invoices[5]
      end

      it "returns a invoice" do
        Invoice.random.is_a?(mock(Invoice).class).should == true
      end
    end

    context "when database has no invoices" do
      it "returns nil" do
        Invoice.random.should == nil
      end
    end
  end

  describe ".find_by" do
    let(:invoice) { mock(Invoice) }
    let(:invoice2) { mock(Invoice) }
    let(:invoice3) { mock(Invoice) }
    let(:duplicate_invoice) { mock(Invoice) }
    let(:invoices) { [invoice, invoice2, invoice3, duplicate_invoice] }

    before(:each) do
      invoice.stub(:id).and_return(1)
      invoice2.stub(:id).and_return(2)
      invoice3.stub(:id).and_return(3)
      duplicate_invoice.stub(:id).and_return(1)
    end

    it "calls find_by attribute" do
      Database.stub(:invoices).and_return(invoices)
      Invoice.find_by_id(2).should == invoice2
    end
  end

  describe ".find_all_by" do
    let(:invoice) { mock(Invoice) }
    let(:invoice2) { mock(Invoice) }
    let(:duplicate_invoice) { mock(Invoice) }
    let(:invoices) { [invoice, invoice2, duplicate_invoice] }

    before(:each) do
      invoice.stub(:id).and_return(1)
      invoice2.stub(:id).and_return(2)
      duplicate_invoice.stub(:id).and_return(1)
    end
    
    it "calls find_all_by attribute" do
      Database.stub(:invoices).and_return(invoices)
      Invoice.find_all_by_id(1).should == [invoice, duplicate_invoice]
    end
  end

  describe "method missing" do
    it "invokes the normal no method error" do
      expect{Invoice.foo}.should raise_error
    end
  end

  describe "respond to" do
    let(:invoice) { Invoice.new(1, "Name", Date.today, Date.today)}
    it "returns true for find_by" do
      invoice.respond_to?("find_by_id").should == true
    end
    it "returns true for find_all_by" do
      invoice.respond_to?("find_all_by_id").should == true
    end
    it "returns false for a method that doesn't exist" do
      invoice.respond_to?("foo").should == false
    end
  end
end