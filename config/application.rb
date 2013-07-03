require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'base64'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Shapd
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
      config.autoload_paths += %W(#{config.root}/lib)
    config.action_view.embed_authenticity_token_in_remote_forms = true
      
      
      config.middleware.use OmniAuth::Builder do
      provider :shapeways,'4f8ab865d305cc3c72adc687d8c75b2104a6e48d', '9fac7670d859df32e05fe9cc9c7cb85e02de6c64'
  end

  end
end
