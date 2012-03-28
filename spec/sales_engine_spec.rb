require 'spec_helper'

describe SalesEngine do
  before(:each) do
    SalesEngine::Persistence.instance.clear
  end

  context ".startup" do
    it "exists" do
      SalesEngine.should respond_to(:startup).with(1).argument
    end

    it "should call load directory" do
      SalesEngine.should_receive :load_directory
      SalesEngine.startup('')
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

  context ".load_directory" do
    let(:directory) { 'spec/fixtures' }

    it "exists" do
      SalesEngine.should respond_to :load_directory
    end

    it "creates models" do
      #SalesEngine.load_directory(directory)
      #SalesEngine::Persistence.instance.dump_data.should_not be_empty
    end
  end
end
