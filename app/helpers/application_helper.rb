module ApplicationHelper
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
