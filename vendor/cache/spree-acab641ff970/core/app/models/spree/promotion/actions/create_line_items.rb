module Spree
  class Promotion
    module Actions
      class CreateLineItems < PromotionAction
        has_many :promotion_action_line_items, foreign_key: :promotion_action_id
        accepts_nested_attributes_for :promotion_action_line_items

        def perform(options = {})
          return unless order = options[:order]
          promotion_action_line_items.each do |item|
            current_quantity = order.quantity_of(item.variant)
            if current_quantity < item.quantity
              order.contents.add(item.variant, item.quantity - current_quantity)
              order.update!
            end
          end
        end
      end
    end
  end
end
