require "net/http"
require "json"

class CurrencyExchangeService
  # Store API key securely via Rails credentials or environment variable
  API_KEY = ENV["EXCHANGE_RATE_API_KEY"]

  BASE_URL = "https://v6.exchangerate-api.com/v6/#{API_KEY}/latest/USD"

  def self.fetch_rates
    raise "Missing API key for exchange rates" unless API_KEY.present?

    uri = URI(BASE_URL)
    response = Net::HTTP.get(uri)
    data = JSON.parse(response)

    if data["result"] == "success"
      data["conversion_rates"].slice("USD", "EUR", "ZMW", "ZAR")
    else
      Rails.logger.error("Exchange rate API failure: #{data['error'] || 'unknown error'}")
      {}
    end
  rescue StandardError => e
    Rails.logger.error("CurrencyExchangeService error: #{e.message}")
    {}
  end
end
