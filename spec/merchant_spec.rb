require './spec/spec_helper'

describe SalesEngine::Merchant do
	describe ".get_merchants" do
		before(:all) { SalesEngine::Merchant.get_merchants }
		it "stores records from merchants.csv in @@records" do
			SalesEngine::Merchant.records.map(&:class).uniq.should == [SalesEngine::Merchant]
		end

		{id: "1", name: "Brekke, Haley and Wolff"}.each do |attribute, value|
			it "records #{attribute}" do
				SalesEngine::Merchant.records.first.send(attribute).should == value
			end
		end
	end

	describe ".by_most_items" do
		pending
		# Merchant.sort_by sold_items_count
		# def Merchant#sold_items_count { Item.find_all_by(:merchant_id, self.id).map(&:sold_count).inject(:+ )}
		# Class Item def sold_count { InvoiceItem.find_all_by(:item_id, self.id).size }
	end

end

#id,name,created_at,updated_at
#1,"Brekke, Haley and Wolff",2012-02-26 20:56:50 UTC,2012-02-26 20:56:50 UTC