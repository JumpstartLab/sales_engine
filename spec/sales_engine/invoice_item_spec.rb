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
    it "returns one invoice item" do
      SalesEngine::Database.instance.stub(:invoice_items).and_return(test_invoice_items)
      SalesEngine::InvoiceItem.find_by_id("4").should be_a SalesEngine::InvoiceItem
    end

    it "is associated with the id passed in" do
      SalesEngine::Database.instance.stub(:invoice_items).and_return(test_invoice_items)
      results = SalesEngine::InvoiceItem.find_all_by_id("4")
      results.sample.id.should == "4"
    end
  end

  describe ".find_all_by_id()" do
    it "returns an array of invoice items" do
      SalesEngine::Database.instance.stub(:invoice_items).and_return(test_invoice_items)
      SalesEngine::InvoiceItem.find_all_by_id("4").all?{|i| i.is_a? SalesEngine::InvoiceItem}.should == true
    end

    it "contains items associated with the id passed in" do
      SalesEngine::Database.instance.stub(:invoice_items).and_return(test_invoice_items)
      results = SalesEngine::InvoiceItem.find_all_by_id("4")
      results.sample.id.should == "4"
    end
  end

  describe ".find_by_item_id()" do
    it "returns one invoice item" do
      SalesEngine::Database.instance.stub(:invoice_items).and_return(test_invoice_items)
      SalesEngine::InvoiceItem.find_by_item_id("123").should be_a SalesEngine::InvoiceItem
    end

    it "is associated with the item_id passed in" do
      SalesEngine::Database.instance.stub(:invoice_items).and_return(test_invoice_items)
      results = SalesEngine::InvoiceItem.find_all_by_item_id("123")
      results.sample.item_id.should == "123"
    end
  end

  describe ".find_all_by_item_id()" do
    it "returns an array of invoice items" do
      SalesEngine::Database.instance.stub(:invoice_items).and_return(test_invoice_items)
      SalesEngine::InvoiceItem.find_all_by_item_id("123").all?{|i| i.is_a? SalesEngine::InvoiceItem}.should == true
    end

    it "contains items associated with the item_id passed in" do
      SalesEngine::Database.instance.stub(:invoice_items).and_return(test_invoice_items)
      results = SalesEngine::InvoiceItem.find_all_by_item_id("123")
      results.sample.item_id.should == "123"
    end
  end

  describe ".find_by_quantity()" do
    it "returns one invoice item" do
      SalesEngine::Database.instance.stub(:invoice_items).and_return(test_invoice_items)
      SalesEngine::InvoiceItem.find_by_quantity("3").should be_a SalesEngine::InvoiceItem
    end

    it "is associated with the quantity passed in" do
      SalesEngine::Database.instance.stub(:invoice_items).and_return(test_invoice_items)
      results = SalesEngine::InvoiceItem.find_all_by_quantity("3")
      results.sample.quantity.should == "3"
    end
  end

  describe ".find_all_by_quantity()" do
    it "returns an array of invoice items" do
      SalesEngine::Database.instance.stub(:invoice_items).and_return(test_invoice_items)
      SalesEngine::InvoiceItem.find_all_by_quantity("3").all?{|i| i.is_a? SalesEngine::InvoiceItem}.should == true
    end

    it "contains items associated with the quantity passed in" do
      SalesEngine::Database.instance.stub(:invoice_items).and_return(test_invoice_items)
      results = SalesEngine::InvoiceItem.find_all_by_quantity("3")
      results.sample.quantity.should == "3"
    end
  end

  describe ".find_by_unit_price()" do
    it "returns one invoice item" do
      SalesEngine::Database.instance.stub(:invoice_items).and_return(test_invoice_items)
      SalesEngine::InvoiceItem.find_by_unit_price("38").should be_a SalesEngine::InvoiceItem
    end

    it "is associated with the unit_price passed in" do
      SalesEngine::Database.instance.stub(:invoice_items).and_return(test_invoice_items)
      results = SalesEngine::InvoiceItem.find_all_by_unit_price("38")
      results.sample.unit_price.should == "38"
    end
  end

  describe ".find_all_by_unit_price()" do
    it "returns an array of invoice items" do
      SalesEngine::Database.instance.stub(:invoice_items).and_return(test_invoice_items)
      SalesEngine::InvoiceItem.find_all_by_unit_price("38").all?{|i| i.is_a? SalesEngine::InvoiceItem}.should == true
    end

    it "contains items associated with the id passed in" do
      SalesEngine::Database.instance.stub(:invoice_items).and_return(test_invoice_items)
      results = SalesEngine::InvoiceItem.find_all_by_unit_price("38")
      results.sample.unit_price.should == "38"
    end
  end

  describe ".find_by_created_at()" do
    it "returns one invoice item" do
      SalesEngine::Database.instance.stub(:invoice_items).and_return(test_invoice_items)
      SalesEngine::InvoiceItem.find_by_created_at("3/31").should be_a SalesEngine::InvoiceItem
    end

    it "is associated with the created_at passed in" do
      SalesEngine::Database.instance.stub(:invoice_items).and_return(test_invoice_items)
      results = SalesEngine::InvoiceItem.find_all_by_created_at("3/31")
      results.sample.created_at.should == "3/31"
    end
  end

  describe ".find_all_by_created_at()" do
    it "returns an array of invoice items" do
      SalesEngine::Database.instance.stub(:invoice_items).and_return(test_invoice_items)
      SalesEngine::InvoiceItem.find_all_by_created_at("3/31").all?{|i| i.is_a? SalesEngine::InvoiceItem}.should == true
    end

    it "contains items associated with the date passed in" do
      SalesEngine::Database.instance.stub(:invoice_items).and_return(test_invoice_items)
      results = SalesEngine::InvoiceItem.find_all_by_created_at("3/31")
      results.sample.created_at.should == "3/31"
    end
  end

  describe ".find_by_updated_at()" do
    it "returns one invoice item" do
      SalesEngine::Database.instance.stub(:invoice_items).and_return(test_invoice_items)
      SalesEngine::InvoiceItem.find_by_updated_at("3/31").should be_a SalesEngine::InvoiceItem
    end

    it "is associated with the updated_at passed in" do
      SalesEngine::Database.instance.stub(:invoice_items).and_return(test_invoice_items)
      results = SalesEngine::InvoiceItem.find_all_by_updated_at("3/31")
      results.sample.updated_at.should == "3/31"
    end
  end

  describe ".find_all_by_updated_at()" do
    it "returns an array of invoice items" do
      SalesEngine::Database.instance.stub(:invoice_items).and_return(test_invoice_items)
      SalesEngine::InvoiceItem.find_all_by_updated_at("3/31").all?{|i| i.is_a? SalesEngine::InvoiceItem}.should == true
    end

    it "contains items associated with the id passed in" do
      SalesEngine::Database.instance.stub(:invoice_items).and_return(test_invoice_items)
      results = SalesEngine::InvoiceItem.find_all_by_updated_at("3/31")
      results.sample.updated_at.should == "3/31"
    end
  end

  describe ".create(attr)" do
    item = Fabricate(:item)

    it "creates an invoice item for an item" do
      SalesEngine::InvoiceItem.create(item).should be_a SalesEngine::InvoiceItem
    end
  end

end

