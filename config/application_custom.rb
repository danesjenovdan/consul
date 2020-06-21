module Consul
  class Application < Rails::Application
    config.i18n.default_locale = 'sl'
    # available_locales = %w(ar de en es fa fr gl he it nl pl pt-BR sq sv val zh-CN zh-TW sl sl-SI)
    # TODO nekega dne je treba pogruntati zakaj rabiš angleški locale, da postaviš sceno
    available_locales = %w(sl it en)
    config.i18n.available_locales = available_locales
    config.i18n.fallbacks = {
      # 'fr' => 'es',
      # 'gl' => 'es',
      # 'it' => 'es',
      # 'pt-BR' => 'es',
      # 'sl-SI' => 'sl',
    }
  end
end
