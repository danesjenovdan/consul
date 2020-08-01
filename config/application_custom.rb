module Consul
  class Application < Rails::Application
    config.i18n.available_locales = ['sl']
    config.i18n.default_locale = :sl
  end
end
