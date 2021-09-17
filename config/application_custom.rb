module Consul
  class Application < Rails::Application
    config.i18n.default_locale = :sl
    available_locales = [
      "sl"
    ]
    config.i18n.available_locales = available_locales

    # Set different path for compiled assets in production.
    # This is required so we can properly mount the volume
    # in several different containers.
    config.assets.prefix = "../../../../pvc"
  end
end
