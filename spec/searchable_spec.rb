require './spec/spec_helper'

CLASSES = [SalesEngine::Merchant, SalesEngine::Customer, SalesEngine::Item, SalesEngine::Invoice, SalesEngine::InvoiceItem, SalesEngine::Transaction]

CLASSES.each do |klass|
	describe "#{klass}" do
	  describe ".all" do
	  	it "returns all of the existing #{klass} records" do
	  		attribute = underscore(klass.to_s.gsub("SalesEngine::", "").downcase + "s").to_sym
				klass.all.should == SalesEngine::Engine.instance.send(attribute)
			end
		end
	end
end