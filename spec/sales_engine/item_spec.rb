require 'spec_helper'

describe SalesEngine::Item do

  let (:test_item){ Fabricate(:item) }

  describe "#invoice_items" do
    context "returns a collection of invoice items" do

      it "contains things which are only invoice items" do
        test_item.invoice_items.all?{|i| i.is_a? SalesEngine::InvoiceItem}.should == true
      end

      it "contains invoice items associated with only this item" do
        test_item.invoice_items.all? {|i|
          i.item_id == test_item.id}.should == true
      end
    end
  end

  describe "#merchant" do
    context "returns a merchant" do
      it "is a merchant" do
        test_item.merchant.should be_a SalesEngine::Merchant
      end

      it "is associated with this item" do
        test_item.merchant.id.should == test_item.merchant_id
      end
    end
  end

  describe ".random" do
    it "is an item" do
      SalesEngine::Item.random.should be_an SalesEngine::Item
    end
  end

  describe "#best_day" do
    it "returns a string of a date" do
      test_item.best_day.should =~ /[0-9][0-9][0-9][0-9][-][0-1][0-9]-[0-3][0-9]/
    end

    it "returns the top sales day for this item" do
      item_1 = Fabricate(:item)
    
      ii_1 = Fabricate(:invoice_item, 
        :updated_at => Time.parse('2012-02-15 13:56:57 UTC'), :quantity => 5 )
      ii_2 = Fabricate(:invoice_item, 
        :updated_at => Time.parse('2012-02-15 13:51:57 UTC'), :quantity => 5)
      ii_3 = Fabricate(:invoice_item, 
        :updated_at => Time.parse('2012-03-15 13:56:57 UTC'), :quantity => 4)

      item_1.invoice_items = [ii_1, ii_2, ii_3]
      item_1.best_day.should == "2012-02-15"
    end
  end

  describe "#item_quantity_per_day" do
    it "returns a hash" do
      test_item.item_quantity_per_day.should be_a Hash
    end

    it "has keys that are dates" do
      test_item.item_quantity_per_day.keys.all? {|k|
        k.should =~ /[0-9][0-9][0-9][0-9][-][0-1][0-9]-[0-3][0-9]/}
    end

    it "has values that are numbers" do
      test_item.item_quantity_per_day.values.all? do |v|
        v.should be_a Integer
      end
    end
  end

  describe '#revenue' do
    it "returns a Big Decimal" do
      test_item.revenue.should be_a BigDecimal
    end

    it "gets the revenue for this item" do
      item_1 = Fabricate(:item, :revenue => 4000)
      item_1.revenue.should == BigDecimal.new(4000)
    end
  end

  describe ".most_revenue(x)" do
    item_1 = Fabricate(:item, :revenue => 3000)
    item_2 = Fabricate(:item, :revenue => 1000)
    item_3 = Fabricate(:item, :revenue => 4000)
    item_4 = Fabricate(:item, :revenue => 2000)

    item_array = [item_1, item_2, item_3, item_4]
    test_x_param = 4

    context "returns the top x item instances ranked by total revenue generated" do
      it "returns an array" do
        SalesEngine::Database.instance.stub(:items).and_return(item_array)
        SalesEngine::Item.most_revenue(4).should be_an Array
      end

      it "contains only items" do
        SalesEngine::Database.instance.stub(:items).and_return(item_array)
        SalesEngine::Item.most_revenue(5).all? do |i|
          i.should be_an SalesEngine::Item
        end
      end

      it "contains as many items as the x parameter" do
        SalesEngine::Database.instance.stub(:items).and_return(item_array)
        SalesEngine::Item.most_revenue(test_x_param).count.should == test_x_param
      end

      it "is ranked by revenue" do
        SalesEngine::Database.instance.stub(:items).and_return(item_array)
        SalesEngine::Item.most_revenue(4).first.revenue.should == 4000
      end
    end
  end

  describe ".most_items(x)" do
    test_x_param = 4
    item_1 = Fabricate(:item, :sales_count => 1)
    item_2 = Fabricate(:item, :sales_count => 3)
    item_3 = Fabricate(:item, :sales_count => 4)
    item_4 = Fabricate(:item, :sales_count => 2)
    item_array = [item_1, item_2, item_3, item_4]

    it "returns an array" do
      SalesEngine::Database.instance.stub(:items).and_return(item_array)
      SalesEngine::Item.most_items(test_x_param).should be_an Array
    end

    it "contains only items" do
      SalesEngine::Database.instance.stub(:items).and_return(item_array)
      SalesEngine::Item.most_items(test_x_param).all? do |i|
        i.should be_a SalesEngine::Item
      end
    end

    it "constains as many items as the x parameter" do
      SalesEngine::Database.instance.stub(:items).and_return(item_array)
      SalesEngine::Item.most_items(test_x_param).count.should == test_x_param
    end

    it "is ranked by count" do
      SalesEngine::Database.instance.stub(:items).and_return(item_array)
      SalesEngine::Item.most_items(4).first.sales_count.should == 4
    end
  end

  describe "#sales_count" do
    test_sales_item = Fabricate(:item)
    ii_1 = Fabricate(:invoice_item, :quantity => 2)
    ii_2 = Fabricate(:invoice_item, :quantity => 2)
    ii_3 = Fabricate(:invoice_item, :quantity => 2)

    ii_array = [ii_1, ii_2, ii_3]
    test_sales_item.invoice_items = ii_array;

    it "returns a number" do
      test_sales_item.sales_count.should be_a Integer
    end

    it "returns the number of successful transactions for this item" do
      test_sales_item.sales_count.should == 6
    end
  end
end
