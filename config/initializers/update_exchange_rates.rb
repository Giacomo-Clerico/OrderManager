  # Only run if cache key is missing or stale

  Rails.application.config.after_initialize do
    unless Rails.cache.exist?("latest_exchange_rates")
      # UpdateExchangeRatesJob.perform_later
    end
  end
