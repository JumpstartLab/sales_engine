require 'spec_helper'

module SalesEngine
  describe Invoice do
    describe "#transactions" do
      let(:transaction) { mock(Transaction) }
      let(:transaction2) { mock(Transaction) }
      let(:other_transaction) { mock(Transaction) }

      before(:each) do
        transaction.stub(:invoice_id).and_return(1)
        transaction2.stub(:invoice_id).and_return(2)
        other_transaction.stub(:invoice_id).and_return(1)
        Transaction.stub(:transactions).and_return([transaction, transaction2, other_transaction])
      end
      context "the invoice has many associated transactions" do
        it "returns an array of all associated transactions" do
          invoice = Fabricate(:invoice, :id => 1)
          invoice.transactions.should == [transaction, other_transaction]
        end
      end
      context "the invoice has one associated transaction" do
        it "returns an array containing the associated transaction" do
          invoice = Fabricate(:invoice, :id => 2)
          invoice.transactions.should == [transaction2]
        end
      end
      context "the invoice has no associated transactions" do
        it "returns an empty array" do
          invoice = Fabricate(:invoice, :id => 3)
          invoice.transactions.should == []
        end
      end
    end

    describe "#invoice_items" do
      let(:invoice_item) { mock(InvoiceItem) }
      let(:invoice_item2) { mock(InvoiceItem) }
      let(:other_invoice_item) { mock(InvoiceItem) }

      before(:each) do
        invoice_item.stub(:invoice_id).and_return(1)
        invoice_item2.stub(:invoice_id).and_return(2)
        other_invoice_item.stub(:invoice_id).and_return(1)
        InvoiceItem.stub(:invoice_items).and_return([invoice_item, invoice_item2, other_invoice_item])
      end
      context "the invoice has many associated invoice_items" do
        it "returns an array of all associated invoice_items" do
          invoice = Fabricate(:invoice, :id => 1)
          invoice.invoice_items.should == [invoice_item, other_invoice_item]
        end
      end
      context "the invoice has one associated invoice_item" do
        it "returns an array containing the associated invoice_item" do
          invoice = Fabricate(:invoice, :id => 2)
          invoice.invoice_items.should == [invoice_item2]
        end
      end
      context "the invoice has no associated invoice_items" do
        it "returns an empty array" do
          invoice = Fabricate(:invoice, :id => 3)
          invoice.invoice_items.should == []
        end
      end
    end

    describe "#items" do
      let(:item) { mock(Item) }
      let(:item2) { mock(Item) }
      let(:other_item) { mock(Item) }

      let(:invoice_item) { mock(InvoiceItem)}
      let(:invoice_item2) { mock(InvoiceItem)}
      let(:other_invoice_item) { mock(InvoiceItem)}

      before(:each) do
        invoice_item.stub(:invoice_id).and_return(1)
        invoice_item2.stub(:invoice_id).and_return(2)
        other_invoice_item.stub(:invoice_id).and_return(1)
        invoice_item.stub(:item).and_return(item)
        invoice_item2.stub(:item).and_return(item2)
        other_invoice_item.stub(:item).and_return(other_item)

        InvoiceItem.stub(:invoice_items).and_return(
          [invoice_item, invoice_item2, other_invoice_item])
      end

      context "the invoice has many associated items" do
        it "returns an array of all associated items" do
          invoice = Fabricate(:invoice, :id => 1)
          invoice.items.should == [item, other_item]
        end
      end
      context "the invoice has one associated item" do
        it "returns an array containing the associated item" do
          invoice = Fabricate(:invoice, :id => 2)
          invoice.items.should == [item2]
        end
      end
      context "the invoice has no associated items" do
        it "returns an empty array" do
          invoice = Fabricate(:invoice, :id => 3)
          invoice.items.should == []
        end
      end
    end

    describe "#customer" do
      let(:invoice) { Fabricate(:invoice, :id => 1, :customer_id => 1) }
      let(:customer) { mock(Customer) }
      let(:other_customer) { mock(Customer) }

      before(:each) do
        customer.stub(:id).and_return(1)
        other_customer.stub(:id).and_return(2)
        Customer.stub(:customers).and_return([customer, other_customer])
      end

      it "returns the customer with matching customer_id" do
        invoice.customer.should == customer
      end
    end

    describe "#create" do
      let (:customer) { double("customer", :id => 1)}
      let (:merchant) { double("merchant", :id => 100)}
      let (:item) { double("item", :id => 200, :unit_price => 1000)}
      let (:item2) { double("item", :id => 201, :unit_price => 2000)}
      let (:invoice) {double("invoice") }

      before(:each) do
        Invoice.stub(:find_by_id).with(1).and_return(invoice)
      end

      it "returns the invoice created" do
        input_hash = { :customer => customer, :merchant => merchant, 
          :status => "status", :items => []}
        Invoice.stub(:insert).and_return(1)
        InvoiceItem.stub(:create_invoice_items)
        Invoice.create(input_hash).should == invoice
      end

      context "when more than 1 invoice item" do
        it "inserts an invoice item for each unique item" do
          items = [item, item2, item]
          hash = { :customer_id => 1, :merchant_id => 100, :status => "status"}
          Invoice.should_receive(:insert).with(hash).and_return(1)
          InvoiceItem.should_receive(:insert).with({
            :item_id => 200, :invoice_id => 1, :quantity => 2, :unit_price => 1000
          })
          InvoiceItem.should_receive(:insert).with({
            :item_id => 201, :invoice_id => 1, :quantity => 1, :unit_price => 2000
          })

          input_hash = { :customer => customer, :merchant => merchant, 
            :status => "status", :items => items}
          Invoice.create(input_hash)
        end
      end

      context "when no invoice items" do
        it "doesn't insert invoice items" do
          Invoice.should_receive(:insert).and_return(1)
          input_hash = { :customer => customer, :merchant => merchant, 
            :status => "status", :items => []}
          InvoiceItem.should_receive(:insert).exactly(0).times

          Invoice.create(input_hash)
        end
      end
    end

    describe "#charge" do
      let(:invoice) { Fabricate(:invoice, :id => 1) }

      it "inserts transaction" do
        input_hash = { }
        hash = { :invoice_id => 1 }
        invoice.stub(:id).and_return(1)
        Transaction.should_receive(:insert).with(hash)
        invoice.charge(input_hash)
      end
    end
  end
end
