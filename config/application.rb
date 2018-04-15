require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TripsRails51
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Site specific settings
    config.i18n.available_locales = [:uk, :ru]
    config.i18n.default_locale = :uk
    config.i18n.fallbacks = true

    config.site = {
      host: 'localhost:3000',
      analytics: false,
      notification_email: 'human.ttp@gmail.com'
    }
    config.example_profile_id = 2
  end
end
