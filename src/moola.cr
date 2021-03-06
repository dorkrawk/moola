require "./moola/*"

module Moola

  class InvalidAmount < Exception
  end

  class CompatabilityError < Exception
  end

  class UnknownCurrencyError < Exception
  end

  class UnavailableConversionError < Exception
  end

  def self.new(amount, currency_name=Money::DEFAULT_CURRENCY_NAME)
    clean_amount = clean_init_amount(amount)
    currency = Moola::Currency.find(currency_name)
    Money.new(clean_amount, currency)
  end

  def self.zero
    Money.new(0)
  end

  protected def self.clean_init_amount(amount)
    case amount
    when Int32
      amount
    when Float64
      (amount * 100).to_i32
    when String
      if amount.to_i?
        amount.to_i32
      elsif amount.to_f?
        self.clean_init_amount(amount.to_f64)
      else
        raise InvalidAmount.new("String doesn't contain valid amount")
      end
    else
      raise InvalidAmount.new
    end
  end
end
