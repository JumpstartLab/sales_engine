require 'spec_helper'

describe SalesEngine::Invoice do

  let(:invoice) do
    i = Fabricate(:invoice)
    #puts i.inspect
    i
  end

  describe ".random" do
    it "returns an invoice" do
      SalesEngine::Invoice.random.class.should == SalesEngine::Invoice
    end

    it "returns different customers on two calls" do
      y = SalesEngine::Invoice.random
      z = SalesEngine::Invoice.random

      while y == z
        y = SalesEngine::Invoice.random
        z = SalesEngine::Invoice.random
      end

      y should_not = z

    end
  end

  # describe "#items" do
  #   it "returns an array" do
  #     SalesEngine::Invoice.random.items.class should == Array
  #   end
  # end
  
end
