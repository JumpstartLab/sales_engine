require 'spec_helper'

describe SalesEngine::Transaction do

  describe "#invoice" do
    it "returns an invoice" do
      SalesEngine::Transaction.random.invoice.class.should == SalesEngine::Invoice
    end
  end

  describe ".random" do
    it "returns a transaction" do
      SalesEngine::Transaction.random.class.should == SalesEngine::Transaction
    end

    it "returns different transactions on two calls" do
      y = SalesEngine::Transaction.random
      z = SalesEngine::Transaction.random

      while y == z
        y = SalesEngine::Transaction.random
        z = SalesEngine::Transaction.random
      end

      y should_not = z

    end
  end
end