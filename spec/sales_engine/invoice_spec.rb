require 'spec_helper'

describe SalesEngine::Invoice do

	test_attr = {id: "1", customer_id: "1", merchant_id: "92", 
                status: "shipped", created_at: "2012-02-14 20:56:56 UTC",
                updated_at: "2012-02-26 20:56:56 UTC"}
 
  let(:test_invoice) {SalesEngine::Invoice.new(test_attr)}
	
  describe "#transactions" do
    context "returns transactions associated with this invoice" do
      it "returns things which are only transactions" do
        test_invoice.transactions.all?{|i| i.is_a? SalesEngine::Transaction}.should == true
      end
    end
  end
end

