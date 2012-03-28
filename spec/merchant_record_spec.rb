require 'spec_helper'

module SalesEngine 
  class MerchantRecordTest
    extend MerchantRecord
  end

  describe MerchantRecord do
    describe "#merchants" do
      it "returns all merchants" do
        MerchantRecordTest.merchants.length.should == 100
      end
    end
  end
end
