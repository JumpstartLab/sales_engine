require './spec/spec_helper.rb'

describe Invoice do

  let(:transaction_one) { Transaction.new(:id => "1", :invoice_id => "1") }
  let(:transaction_two) { Transaction.new(:id => "2", :invoice_id => "2", :status => "failure") }
  let(:transaction_three) { Transaction.new(:id => "3", :invoice_id => "2", :status => "success") }
  let(:customer_zero) { Customer.new(:id => "0") }
  let(:customer_one) { Customer.new(:id => "1") } 
  let(:invoice_one) { Invoice.new(:id => "1", :customer_id => "0") }
  let(:invoice_two) { Invoice.new(:id => "2", :customer_id => "2") }
  let(:invoice_three) { Invoice.new(:id => "3", :customer_id => "0") }

  describe "#transactions" do
    it "returns an array of transactions" do
        Database.instance.transaction_list = [ transaction_one, transaction_two, transaction_three ]
        invoice_two.transactions.should == [ transaction_two, transaction_three ]
    end

    context "when an invoice has no transactions" do
      it "returns an empty array" do
        invoice_three.transactions.should == [ ]
      end
    end
  end

  
  
  # describe "#invoice_items" do
  #   it "returns an array of invoices_items" do
  #     customer_zero.invoices.should == [invoice_one, invoice_three]
  #   end

  #   context "when customer has no invoices" do
  #     it "returns an empty array" do
  #       customer_one.invoices.should == [ ]
  #     end
  #   end
  # end
   # describe "#transactions" do
  #   it "returns an array of invoices" do
  #     customer_zero.invoices.should == [invoice_one, invoice_three]
  #   end

  #   context "when customer has no invoices" do
  #     it "returns an empty array" do
  #       customer_one.invoices.should == [ ]
  #     end
  #   end
  # end
   # describe "#transactions" do
  #   it "returns an array of invoices" do
  #     customer_zero.invoices.should == [invoice_one, invoice_three]
  #   end

  #   context "when customer has no invoices" do
  #     it "returns an empty array" do
  #       customer_one.invoices.should == [ ]
  #     end
  #   end
  # end

  describe ".random" do
    it "returns a random instance of customer in customer_list" do
    end

    context "returns nil when there are no customers" do
    end
  end

  describe ".find_by_id" do
    it "returns a single customer whose id matches param" do
    end

    context "returns nil when there are no customers" do
    end
  end

  describe ".find_by_first_name" do
    it "returns a single customer whose first_name matches param" do
    end

    context "returns nil when there are no customers" do
    end    
  end

  describe ".find_by_last_name" do
    it "returns a single customer whose last_name matches param" do
    end

    context "returns nil when there are no customers" do
    end    
  end

  describe ".find_by_created_at" do
    it "returns a single customer whose created_at matches param" do
    end

    context "returns nil when there are no customers" do
    end    
  end

  describe ".find_by_updated_at" do
    it "returns a single customer whose updated_at matches param" do
    end

    context "returns nil when there are no customers" do
    end    
  end
end