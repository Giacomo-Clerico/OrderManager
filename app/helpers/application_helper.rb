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

  def remaining_pay(quote)
    total_amount = quote.items.sum(:price)
    return 0 if total_amount.nil? || quote.payments.sum(:amount).nil?

    total_amount - quote.payments.sum(:amount)
  end
end
