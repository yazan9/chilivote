require File.expand_path('../boot', __FILE__)

require 'rails/all'
# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Chilivote
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
    config.assets.initialize_on_precompile = false
    config.assets.precompile += %w(*.png *.jpg *.jpeg *.gif)
    config.default_profile_image = "v1401984216/ic_red_background_-_Copy_pqoudp.png"
    
    #defined constants
    config.contribution_type_cvote = 1
    config.contribution_type_poll = 2
    config.contribution_type_post = 3
    config.contribution_type_status = 4
    
    config.privacy_friends_only = 1
    config.privacy_public = 2
    
    config.vote_type_up = 1
    config.vote_type_down = 2
    config.vote_type_single = 3
    
    config.like_up = 2
    config.like_down = 1
  end
end
