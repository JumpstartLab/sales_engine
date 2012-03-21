require './spec/spec_helper'

CLASSES = {SalesEngine::Merchant => "merchants", SalesEngine::Customer => "customers", SalesEngine::Item => "items", SalesEngine::Invoice => "invoices", SalesEngine::InvoiceItem => "invoice_items", SalesEngine::Transaction => "transactions"}

CLASSES.each do |klass, attribute|
	describe "#{klass}" do
		describe ".all" do
			it "returns all of the existing #{klass} records" do
				klass.all.should == SalesEngine::Engine.instance.send(attribute.to_sym)
			end
		end
	end
end
