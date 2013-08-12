# Configure Spree Preferences
#
# Note: Initializing preferences available within the Admin will overwrite any changes that were made through the user interface when you restart.
#       If you would like users to be able to update a setting with the Admin it should NOT be set here.
#
# In order to initialize a setting do:
# config.setting_name = 'new value'
Spree.config do |config|
    # Example:
    # Uncomment to override the default site name.
    # config.site_name = "Spree Demo Site"
    config.default_country_id = 1

end

Spree.user_class = "User"

Spree::Config.set(logo: "store/shapd.png")
Spree::Config[:track_inventory_levels] = false


Spree::StockItem.class_eval do
    attr_accessible :variant, :backorderable
end

Rails.application.config.to_prepare do
    require_dependency 'spree/authentication_helpers'
end

Spree::Payment.class_eval do
    attr_accessible :amount, :payment_method_id
end

Spree::StockMovement.class_eval do
    attr_accessible :quantity, :originator
end


Spree::Order.class_eval do
    attr_accessible :payments_attributes, :email
end


Spree::StockItem.class_eval do
    attr_accessible :variant, :backorderable
end


Spree::Config[:track_inventory_levels] = false

Spree::Image.class_eval do
    attr_accessible :attachment
end

Spree::Taxonomy.class_eval do
    attr_accessible :name
end

Spree::Taxon.class_eval do
    attr_accessible :taxonomy_id, :name
end


Spree::ShippingMethod.class_eval do
    attr_accessible :name, :display_on, :tracking_url, :calculator_type
    attr_accessible :calculator_attributes
    
end

Spree::StockLocation.class_eval do
    attr_accessible :name, :active, :backorderable_default, :propagate_all_variants, :address1, :address2, :city, :zipcode, :country_id, :state_id, :phone
end

Spree::Gateway::PayPal.class_eval do
    attr_accessible :environment, :display_on, :active, :name, :description
end

Spree::Gateway::Bogus.class_eval do
    attr_accessible :environment, :display_on, :active, :name, :description
end



Spree::LineItem.class_eval do
    attr_accessible :quantity
end

Spree::TaxRate.class_eval do
    attr_accessible :name, :amount, :included_in_price, :zone_id, :tax_category_id, :show_rate_in_label, :calculator_type
end

Spree::Adjustment.class_eval do
	attr_accessible :amount, :source, :originator, :label, :mandatory, :state, :eligible
end

Spree::Zone.class_eval do
    attr_accessible :name, :description, :default_tax, :kind, :zone_members_attributes

end

Spree::ZoneMember.class_eval do
    attr_accessible :zoneable_type, :zoneable_id
end


Spree::TaxCategory.class_eval do
    attr_accessible :name, :description, :is_default
end


Spree::Calculator::Shipping::FlatRate.class_eval do
    attr_accessible :preferred_amount, :preferred_currency
end

Spree::ShippingRate.class_eval do
    attr_accessible :shipping_method, :cost
end

Spree::ShippingCategory.class_eval do
    attr_accessible :name
end

Spree::Prototype.class_eval do
    attr_accessible :name, :property_ids, :option_type_ids
end


Spree::Address.class_eval do
    attr_accessible :country
    attr_accessible :firstname, :lastname, :address1, :address2, :city, :country_id, :zipcode, :phone
    attr_accessible :firstname, :lastname, :address1, :address2, :city, :zipcode, :phone, :state_name, :alternative_phone, :company, :state_id, :country_id
end

Spree::Property.class_eval do
    attr_accessible :name, :presentation
end

Spree::OptionType.class_eval do
    attr_accessible :name, :presentation
end



Spree::StateChange.class_eval do
    attr_accessible :previous_state, :next_state, :name, :user_id
end

Spree::ShippingRate.class_eval do
    attr_accessible :selected
end


Spree::Order.class_eval do
    attr_accessible :use_billing, :bill_address_attributes
    attr_accessible :coupon_code, :line_items_attributes
    attr_accessible :payment_state, :shipping_method, :shipment_state, :item_total, :adjustment_total, :payment_total, :total
    attr_accessible :ship_address_attributes
    attr_accessible :currency
end


Spree::Product.class_eval do
    attr_accessible :name, :price, :description, :id
    attr_accessible :permalink, :cost_price, :cost_currency, :available_on, :sku, :weight, :height, :width, :depth, :shipping_category_id, :tax_category_id, :taxon_ids, :option_type_ids, :meta_keywords, :meta_description
    attr_accessible :prototype_id
    
end

Spree::Gateway::StripeGateway.class_eval do
    attr_accessible :environment, :display_on, :active, :name, :description
    attr_accessible :preferred_server, :preferred_test_mode

end