require 'spec_helper'

describe SalesEngine::Invoice do
  let(:se) { SalesEngine::Database.instance}

  describe ".startup" do
    it "loads data into the database in order to prepare the program to run" do
      se.should_receive(:load_data)
      SalesEngine.startup
    end
  end
end