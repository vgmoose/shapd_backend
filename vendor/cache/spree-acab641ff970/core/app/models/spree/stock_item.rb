module Spree
  class StockItem < ActiveRecord::Base
    belongs_to :stock_location, class_name: 'Spree::StockLocation'
    belongs_to :variant, class_name: 'Spree::Variant'
    has_many :stock_movements, dependent: :destroy

    validates_presence_of :stock_location, :variant
    validates_uniqueness_of :variant_id, scope: :stock_location_id

    after_save :process_backorders

    delegate :weight, to: :variant

    def backordered_inventory_units
      Spree::InventoryUnit.backordered_for_stock_item(self)
    end

    def variant_name
      variant.name
    end

    def adjust_count_on_hand(value)
      self.with_lock do
        self.reload
        self.update_attribute(:count_on_hand, self.count_on_hand + value)
        self.save!
      end
    end

    def in_stock?
      self.count_on_hand > 0
    end

    # Tells whether it's available to be included in a shipment
    def available?
      self.in_stock? || self.backorderable?
    end

    private
    def count_on_hand=(value)
      write_attribute(:count_on_hand, value)
    end

    def process_backorders
      return unless changes['count_on_hand'] && changes['count_on_hand'].last.to_i > 0

      backordered_units = backordered_inventory_units
      while in_stock? && !backordered_units.empty?
        inventory_unit = backordered_units.shift
        inventory_unit.fill_backorder
        self.adjust_count_on_hand(-1)
      end
    end
  end
end
