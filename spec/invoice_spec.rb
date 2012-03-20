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
    context ".find_by_id" do
      it "should have generated the class method" do
        Invoice.should be_respond_to(:find_by_id)
      end
      it "should return an Invoice or nil" do
        invoice = Invoice.find_by_id(1)
        invoice.should be_nil || be_is_a(Invoice)
      end
    end

    context ".find_by_merchant_id" do
      it "should have generated the class method" do
        Invoice.should be_respond_to(:find_by_merchant_id)
      end
      it "should return an Invoice or nil" do
        invoice = Invoice.find_by_merchant_id(1)
        invoice.should be_nil || be_is_a(Invoice)
      end
    end
  end
end