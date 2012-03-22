require 'spec_helper'

describe SalesEngine::Database do

  describe "#get_merchants" do

    context "loads a merchant array" do

      let(:test_db) {SalesEngine::Database.instance}

      it "which is not nil" do
        test_db.get_merchants.should_not == nil
      end

      it "which contains at least one merchant" do
        test_db.get_merchants.count.should >= 1
      end

      it "loaded as many merchants as are in the CSV file"
      

    end

  end

end
