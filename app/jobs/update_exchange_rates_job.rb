class UpdateExchangeRatesJob < ApplicationJob
  queue_as :default

  def perform
    rates = CurrencyExchangeService.fetch_rates
    Rails.cache.write("latest_exchange_rates", rates, expires_in: 1.hour)
  end
  
end
