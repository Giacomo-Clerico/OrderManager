module OrdersHelper
  def convert_currency(amount, from_currency, to_currency)
    rates = { "USD" => 1.0, "ZMW" => 24.5 } # Replace with API call if needed

    # Convert amount to USD first, then to target currency
    amount_in_usd = amount / rates[from_currency]
    (amount_in_usd * rates[to_currency]).round(2)
  end

  def currency_symbol_for(currency_code)
    case currency_code
    when "USD" then "$"
    when "ZAR" then "R"
    when "ZMW" then "ZK"
    when "EUR" then "€"
    else
      currency_code.to_s.presence || ""
    end
  end
end
