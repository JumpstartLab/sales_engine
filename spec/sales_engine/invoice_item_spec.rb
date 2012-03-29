require 'spec_helper'


describe SalesEngine::InvoiceItem do

  let(:test_invoice_item){Fabricate(:invoice_item)}

  describe "#item" do
    context "returns an item associated with this invoice item" do
      it "returns an item" do
        test_invoice_item.item.is_a?(SalesEngine::Item).should == true
      end

      it "returns an item associated with this invoice item" do
        test_invoice_item.item.id.should == test_invoice_item.item_id
      end
    end
  end

  describe "#invoice" do
    context "returns an invoice associated with this invoice_item" do

      it "returns an invoice" do
        test_invoice_item.invoice.is_a?(SalesEngine::Invoice).should == true
      end

      it "returns an invoice associated with this invoice item" do
        test_invoice_item.invoice.id.should == test_invoice_item.invoice_id
      end
    end
  end

  describe ".random" do
    it "returns on invoice_item" do
      SalesEngine::InvoiceItem.random.should be_a SalesEngine::InvoiceItem
    end
  end

  describe "#invoice_item_total" do
    context "returns quantity * unit price for this invoice_item" do

      it "returns an integer" do
        test_invoice_item.total.should be_a Integer
      end

      it "multiplies quantity * unit price correctly" do
        test_invoice_item.quantity = "4"
        test_invoice_item.unit_price = "1000"
        test_invoice_item.total.should == 4000
      end
    end
  end

  test_invoice_items = [  Fabricate(:invoice_item,
                                    :id => "4",
                                    :item_id => "123",
                                    :quantity => "3",
                                    :unit_price => "38",
                                    :created_at => "3/31",
                                    :updated_at => "3/31"
                                    ),
                          Fabricate(:invoice_item,
                                    :id => "4",
                                    :item_id => "123",
                                    :quantity => "3",
                                    :unit_price => "38",
                                    :created_at => "3/31",
                                    :updated_at => "3/31"
                                    ),
                          Fabricate(:invoice_item,
                                    :id => "4",
                                    :item_id => "123",
                                    :quantity => "3",
                                    :unit_price => "38",
                                    :created_at => "3/31",
                                    :updated_at => "3/31"
                                    )]

  describe ".find_by_id()" do
    it "returns one invoice item"
      SalesEngine::Database.instance.stub(:invoice_item).and_return(test_invoice_items)
      SalesEngine::InvoiceItem.find_by_id("4").should be_a SalesEngine::InvoiceItem
    end
  end



end

