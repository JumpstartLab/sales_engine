require 'spec_helper'

describe SalesEngine do
  context ".startup" do
    it "exists" do
      SalesEngine.should respond_to :startup
    end

    it "should call load" do
      SalesEngine.should_receive :load
      SalesEngine.startup
    end
  end

  context ".load" do
    let(:filename) { 'spec/fixtures/merchants.csv' }

    it "exists" do
      SalesEngine.should respond_to :load
    end

    it "creates models" do
      SalesEngine.load(filename)
      SalesEngine::Persistence.instance.dump_data.should_not be_empty
    end
  end
end
