require './spec/spec_helper'

describe SalesEngine::Invoice do
	describe ".get_invoices" do
		before(:all) { SalesEngine::Invoice.get_invoices }
		it "stores records from invoices.csv" do
			SalesEngine::Invoice.records.map(&:class).uniq.should == [SalesEngine::Invoice]
		end

		{id: "1", customer_id: "1",
		merchant_id: "92", status: "shipped"}.each do |attribute, value|
			it "records #{attribute}" do
			  SalesEngine::Invoice.records.first.send(attribute).should == value
		  end
	  end
	end

	context "instance methods" do
		let(:invoice) { SalesEngine::Invoice.find_by_id('1') }
		describe "#transactions" do
			it "returns transactions" do
				invoice.transactions.should_not be_empty
				invoice.transactions.first.should be_a(SalesEngine::Transaction)
			end
			it "returns all transactions with the invoice of the instance" do
				invoice.transactions.size.should == 1
			end
		end
		describe "#invoice_items" do
			it "returns invoice_items" do
				invoice.invoice_items.should_not be_empty
				invoice.invoice_items.first.should be_a(SalesEngine::InvoiceItem)
			end
			it "returns all invoice_items with the invoice of the instance" do
				invoice.invoice_items.size.should == 4
			end
		end
		describe "#items" do
			it "returns items" do
				invoice.items.should_not be_empty
				invoice.items.first.should be_a(SalesEngine::Item)
			end
			it "returns all items with the invoice of the instance" do
				invoice.items.size.should == 4
			end

			it "does not return duplicates of the same item" do
				SalesEngine::Invoice.find_by_id('2').items.size.should == 1
			end
		end
		describe "#customer" do
			it "returns a customer" do
				invoice.customer.should be_a(SalesEngine::Customer)
			end
			it "returns its customer" do
				invoice.customer.should == SalesEngine::Customer.find_by_id('1')
			end
		end
	end
end
#id,customer_id,merchant_id,status,created_at,updated_at
#1,1,92,shipped,2012-02-14 20:56:56 UTC,2012-02-26 20:56:56 UTC