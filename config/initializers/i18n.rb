Rails.application.configure do
  # Set available locales
  config.i18n.available_locales = [ :en, :pt_br ]

  # Set default locale to Portuguese Brazil
  config.i18n.default_locale = :pt_br

  # Fallback to English if translation is missing
  config.i18n.fallbacks = [ :en ]

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to English when a translation cannot be found)
  config.i18n.fallbacks = [ I18n.default_locale ]

  # Load all locale files from subdirectories
  config.i18n.load_path += Dir[Rails.root.join("config", "locales", "**", "*.{rb,yml}")]
end
