require './spec/spec_helper'

describe SalesEngine::Merchant do
	describe "#items" do
		it "returns a collection of items" do
			merchant = SalesEngine::Merchant.new
			merchant.items.should be_an Array
		end
	end


	# Alias this to .most_items for API compliance
	describe ".by_most_items" do
		# Merchant.sort_by sold_items_count
		# def Merchant#sold_items_count { Item.find_all_by(:merchant_id, self.id).map(&:sold_count).inject(:+ )}
		# Class Item def sold_count { InvoiceItem.find_all_by(:item_id, self.id).size }
	end

end