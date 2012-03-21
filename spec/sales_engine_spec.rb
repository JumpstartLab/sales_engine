require './spec/spec_helper'

describe SalesEngine::Engine do
	describe "#initialize" do
		[:merchants, :customers, :invoices, :invoice_items, :transactions, :items].each do |attribute|
			it "loads proper data into the #{attribute}" do
				SalesEngine::Engine.instance.send(attribute).size.should > 1
			end
		end
	end
end