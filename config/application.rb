require File.expand_path('../boot', __FILE__)

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Circlus
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

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    # SYC extension for make production glyphicons aware
    config.assets.paths << Rails.root.join("vendor",
                                           "assets",
                                           "bower_components")

    config.assets.paths << Rails.root.join("vendor",
                                           "assets",
                                           "bower_components",
                                           "bootstrap-sass-official",
                                           "assets",
                                           "fonts")
    config.assets.precompile << /\.(?:svg|eot|woff|ttf|woff2)\z/

    # SYC extension for making PostgreSQL functions aware in tests
    config.active_record.schema_format = :sql

    # SYC extension for reading the version number
    config.version = File.read('config/version')

    # SYC extension for pdf template. 
    # Configure classes that should be used in pdf templates
    config.pdf_template_classes = [:organization, :member, :group, :event]
  end
end
