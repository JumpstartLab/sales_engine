require './spec/spec_helper'

CLASSES = {SalesEngine::Merchant => "merchants", SalesEngine::Customer => "customers", SalesEngine::Item => "items", SalesEngine::Invoice => "invoices", SalesEngine::InvoiceItem => "invoice_items", SalesEngine::Transaction => "transactions"}

CLASSES.each do |klass, attribute|
	describe "#{klass}" do
		describe ".all" do
			it "returns all of the existing #{klass} records" do
				klass.all.should == SalesEngine::Engine.instance.send(attribute.to_sym)
			end
		end
		describe ".random" do
			it "returns a single instance of #{klass}" do
				klass.send(:random).should be_a(klass)
			end
		end
	  describe ".find_all_by_id('10')" do
			it "returns the instance of #{klass} with ID '10' " do
				klass.send(:find_all_by_id, '10').first.id.should == '10'
			end
		end



	end
end
