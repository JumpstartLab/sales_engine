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

		describe ".find_by_id('7')" do
	    it "returns one instance of #{klass} with ID '7' " do
				klass.send(:find_by_id, '7').id.should == '7'
			end
		end

	  describe ".find_all_by_id('10')" do
			it "returns the instances of #{klass} with ID '10' " do
				klass.send(:find_all_by_id, '10').map(&:id).should == ['10']
			end
			it "doesn't miss any records with id of '10'" do
				all_tens = klass.send(:find_all_by_id, '10')
				(klass.all - all_tens).map(&:id).include?("10").should be_false
			end
		end

		#TODO: Assert error message includes faulty method name
		describe ".find_by_foo_bar('42')" do
			it "raises a method missing error" do
				expect { klass.send(:find_by_foo_bar, '42') }.should raise_error(NoMethodError)
			end
		end

	end
end
