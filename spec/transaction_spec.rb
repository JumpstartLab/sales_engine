require './spec/spec_helper.rb'
require "./transaction.rb"

describe Transaction do
  describe 'find_by_#{attribute}(attribute) methods' do
    Transaction::ATTRIBUTES.each do |attribute|
      context ".find_by_#{attribute}" do
        it "should have generated the class method" do
          Transaction.should be_respond_to("find_by_#{attribute}")
        end
      end
    end
  end

  describe 'test accessors' do
    let(:test_transaction) { Transaction.new({id: 10}) }
    Transaction::ATTRIBUTES.each do |attribute|
      context "responds to attr_accessors" do
        it "generates the reader" do
          test_transaction.should be_respond_to("#{attribute}")
        end
        it "generates the writer" do
          test_transaction.should be_respond_to("#{attribute}=")
        end
      end
    end
  end
end