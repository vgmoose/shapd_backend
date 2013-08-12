require 'spec_helper'

module Spree
  module Stock
    describe Coordinator do
      let(:package) { build(:stock_package_fulfilled) }
      let(:order) { package.order }
      let(:stock_location) { package.stock_location }

      subject { Coordinator.new(order) }

      before :all do
        Rails.application.config.spree.stock_splitters = [
         Spree::Stock::Splitter::Backordered,
         Spree::Stock::Splitter::ShippingCategory
        ]
      end

      it 'builds a list of packages for an order' do
        StockLocation.should_receive(:active).and_return([stock_location])
        subject.should_receive(:build_packer).and_return(double(:packages => [package]))
        Estimator.any_instance.should_receive(:shipping_rates).and_return([])

        packages = subject.packages
        packages.count.should == 1
      end
    end
  end
end
