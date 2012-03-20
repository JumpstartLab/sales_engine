require './spec/spec_helper'

describe SalesEngine::Merchant do
	describe ".get_merchants" do
		before(:each) { SalesEngine::Merchant.get_merchants }
		it "stores records from merchants.csv in @@records" do
			SalesEngine::Merchant.records.map(&:class).uniq.should == [SalesEngine::Merchant]
		end

	  it "stores an id" do
			SalesEngine::Merchant.records.first.id.should == '1'
		end

		it "stores a name" do
			SalesEngine::Merchant.records.first.name.should == "Brekke, Haley and Wolff"
		end

	end

	describe ".by_most_items" do
		pending
		# Merchant.sort_by sold_items_count
		# def Merchant#sold_items_count { Item.find_all_by(:merchant_id, self.id).map(&:sold_count).inject(:+ )}
		# Class Item def sold_count { InvoiceItem.find_all_by(:item_id, self.id).size }
	end

end