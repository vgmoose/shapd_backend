require 'spec_helper'

describe Spree::LineItem do
  let(:order) { create :order_with_line_items, line_items_count: 1 }
  let(:line_item) { order.line_items.first }
  before do
    Spree::Config.set :allow_backorders => true
  end

  context '#save' do
    it 'should update inventory, totals, and tax' do
      # Regression check for #1481
      line_item.order.should_receive(:create_tax_charge!)
      line_item.order.should_receive(:update!)
      line_item.quantity = 2
      line_item.save
    end
  end

  context '#destroy' do
    # Regression test for #1481
    it "applies tax adjustments" do
      line_item.order.should_receive(:create_tax_charge!)
      line_item.destroy
    end
  end

  describe '.currency' do
    it 'returns the globally configured currency' do
      line_item.currency == 'USD'
    end
  end

  describe ".money" do
    before do
      line_item.price = 3.50
      line_item.quantity = 2
    end

    it "returns a Spree::Money representing the total for this line item" do
      line_item.money.to_s.should == "$7.00"
    end
  end

  describe '.single_money' do
    before { line_item.price = 3.50 }
    it "returns a Spree::Money representing the price for one variant" do
      line_item.single_money.to_s.should == "$3.50"
    end
  end
end

