require 'spec_helper'

describe SalesEngine::Invoice do
  let(:valid_invoice) { Fabricate(:invoice) }
  let(:valid_merchant) { Fabricate(:merchant) }
  let(:valid_customer) { Fabricate(:customer) }
  
  it "can be created" do
    valid_invoice.should_not be_nil
  end

  it "has a customer_id" do
    valid_invoice.customer_id.should_not be_nil
  end

  it "can't be created with a nil customer" do
    expect do
      SalesEngine::Invoice.new(
        :id => 1,
        :customer => nil,
        :merchant => valid_merchant,
        :status => 'shipped'
      )
    end.to raise_error ArgumentError
  end

  it "has a merchant_id" do
    valid_invoice.merchant_id.should_not be_nil
  end

  it "can't be created with a nil merchant" do
    expect do
      SalesEngine::Invoice.new(
        :id => 1,
        :customer => valid_customer,
        :merchant => nil,
        :status => 'shipped'
      )
    end.to raise_error ArgumentError
  end

  it "has a status" do
    valid_invoice.status.should_not be_nil
  end

  it "can't be created with a nil status" do
    expect do
      SalesEngine::Invoice.new(
        :id => 1,
        :customer => valid_customer,
        :merchant => valid_merchant,
        :status => nil
      )
    end.to raise_error ArgumentError
  end

  it "can't be created with a blank status" do
    expect do
      SalesEngine::Invoice.new(
        :id => 1,
        :customer => valid_customer,
        :merchant => valid_merchant,
        :status => ''
      )
    end.to raise_error ArgumentError
  end

  # harness specs

  context "Searching" do
    describe ".random" do
      it "usually returns different things on subsequent calls" do
        invoice_one = SalesEngine::Invoice.random
        invoice_two = SalesEngine::Invoice.random

        10.times do
          break if invoice_one.id != invoice_two.id
          invoice_two = SalesEngine::Invoice.random
        end

        invoice_one.id.should_not == invoice_two.id
      end
    end

    describe ".find_by_status" do
      it "can find a record" do
        invoice = SalesEngine::Invoice.find_by_status "cool"
        invoice.should be_nil
      end
    end

    describe ".find_all_by_status" do
      it "can find multiple records" do
        invoices = SalesEngine::Invoice.find_all_by_status "shipped"
        puts invoices.map(&:status).uniq
        invoices.should have(4843).invoices
      end
    end
  end

  context "Relationships" do
    let(:invoice) { SalesEngine::Invoice.find_by_id 1002 }

    describe "#transactions" do
      it "has 1 of them" do
        invoice.transactions.should have(1).transaction
      end
    end

    describe "#items" do
      it "has 3 of them" do
        invoice.items.should have(3).items
      end

      it "has one for 'Item Accusamus Officia'" do
        item = invoice.items.find {|i| i.name == 'Item Accusamus Officia' }
        item.should_not be_nil
      end
    end

    describe "#customer" do
      it "exists" do
        invoice.customer.first_name.should == "Eric"
        invoice.customer.last_name.should  == "Bergnaum"
      end
    end

    describe "#invoice_items" do
      it "has 3 of them" do
        invoice.invoice_items.should have(3).items
      end

      it "has one for an item 'Item Accusamus Officia'" do
        item = invoice.invoice_items.find {|ii| ii.item.name == 'Item Accusamus Officia' }
        item.should_not be_nil
      end
    end
  end

  context "Business Intelligence" do

    describe ".create" do
      let(:customer) { SalesEngine::Customer.random }
      let(:merchant) { SalesEngine::Merchant.random }
      let(:items) do
        (1..3).map { SalesEngine::Item.random }
      end
      it "creates a new invoice" do

        invoice = SalesEngine::Invoice.create(customer: customer, merchant: merchant, items: items)

        items.map(&:name).each do |name|
          invoice.items.map(&:name).should include(name)
        end

        #invoice.merchant.id.should == merchant.id
        invoice.customer.id.should == customer.id
      end
    end

    describe "#charge" do
      it "creates a transaction" do
        invoice = SalesEngine::Invoice.find_by_id(100)
        prior_transaction_count = invoice.transactions.count

        invoice.charge(credit_card_number: '1111222233334444',  credit_card_expiration_date: "10/14", result: "success")

        invoice = SalesEngine::Invoice.find_by_id(invoice.id)
        invoice.transactions.count.should == prior_transaction_count + 1
      end
    end

  end
end
