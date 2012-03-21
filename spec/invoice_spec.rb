require "./merchant"
require "./customer"
require "./transaction"
require "./invoice"
require "./item"
require "./invoice_item"
require "rspec"
require "date"
require 'ap'

describe Invoice do
  describe 'find_by_#{attribute}(attribute) methods' do
    Invoice::ATTRIBUTES.each do |attribute|
      context ".find_by_#{attribute}" do
        it "should have generated the class method" do
          Invoice.should be_respond_to("find_by_#{attribute}")
        end
      end
    end
  end

  describe 'test accessors' do
    let(:test_invoice) { Invoice.new }
    Invoice::ATTRIBUTES.each do |attribute|
      context "responds to attr_accessors" do
        it "generates the reader" do
          test_invoice.should be_respond_to("#{attribute}")
        end
        it "generates the writer" do
          test_invoice.should be_respond_to("#{attribute}=")
        end
      end
    end
  end
end