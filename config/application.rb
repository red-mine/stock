require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

require "stave"
require "stock"

module StockApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Custom directories with classes and modules you want to be autoloadable.
    config.autoloader = :zeitwerk

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    config.time_zone = "Central Time (US & Canada)"
    config.eager_load_paths << Rails.root.join("extras")

    config.eager_load_paths += %W(
      #{config.root}/lib/stock
      #{config.root}/lib/stave
    )

    config.autoload_paths << Rails.root.join("extras")
    config.add_autoload_paths_to_load_path = true
  end
end
