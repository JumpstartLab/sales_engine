require 'spec_helper'

describe SalesEngine::Merchant do

  test_attr = {:id => "100", :name => "Jakubowski, Buckridge and Kovacek",
    :created_at => "2012-02-26 20:56:56 UTC",
    :updated_at => "2012-02-26 20:56:56 UTC"}
  
  let(:test_merchant){SalesEngine::Merchant.new(test_attr)}
  
  describe "#items" do 

    context "returns a collection of items" do

      it "contains things which are only items" do
        test_merchant.items.all?{|i| i.is_a? SalesEngine::Item}.should == true
      end

      it "contains items associated with only this merchant" do
        test_merchant.items.all? {|i| 
          i.merchant_id == test_merchant.id}.should == true
      end
    end

  end
end


# array.all?{|i|i.is_a? Integer}