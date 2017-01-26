module Moola
  class Exchange
    @@conversions = {} of Moola::Currency => Hash(Moola::Currency, Float64)

    def self.conversions
      @@conversions
    end

    def self.clear_conversions
      @@conversions = {} of Moola::Currency => Hash(Moola::Currency, Float64)
    end

    def self.add_conversion(from : Moola::Currency, to : Moola::Currency, conversion_rate : Float64)
      from_hash = @@conversions[from]? || {} of Moola::Currency => Float64
      from_hash[to] = conversion_rate
      @@conversions[from] = from_hash
    end

    def self.conversion_exists?(from : Moola::Currency, to : Moola::Currency)
      @@conversions.keys.includes?(from) && @@conversions[from].keys.includes?(to)
    end

    def self.convert(money : Moola::Money, currency : Moola::Currency)
      if self.conversion_exists?(money.currency, currency)
        rate = @@conversions[money.currency][currency]
        converted_amount = (money.amount * rate).to_i32
        Money.new(converted_amount, currency)
      else
        raise UnavailableConversionError.new("No conversion available for #{money.currency.iso_code} -> #{currency.iso_code}")
      end
    end
  end
end
