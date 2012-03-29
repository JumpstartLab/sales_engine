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

  describe ".find_by_id" do
    id = rand(2000) + 1
    it "returns a transaction" do
      SalesEngine::Transaction.find_by_id(id).class.should == SalesEngine::Transaction
    end
  end

  describe ".find_all_by_id" do
    id = rand(2000) + 1
    it "returns an array" do
      SalesEngine::Transaction.find_all_by_id(id).class.should == Array
    end

    it" returns an array with transactions" do
      SalesEngine::Transaction.find_all_by_id(id).each do |t|
        t.class.should == SalesEngine::Transaction
      end
    end
  end
end