module Moola
  class Money
    DEFAULT_CURRENCY_NAME = "USD"
    DEFAULT_CURRENCY = Moola::Currency.find(DEFAULT_CURRENCY_NAME)

    getter amount, currency

    def initialize(@amount : Int32, @currency : Moola::Currency = DEFAULT_CURRENCY)
    end

    def format
      currency_symbol = currency.symbol
      decimal_mark = currency.decimal_mark
      subunit_shift = Math.log(currency.subunit_to_unit, 10).to_i
      amount_str = amount.to_s
      unit_str = amount_str[0, amount_str.size - subunit_shift]
      subunit_str = amount_str[amount_str.size - subunit_shift, amount_str.size]
      formatted_value = "#{unit_str}#{decimal_mark}#{subunit_str}"
      if currency.symbol_first
        currency_symbol + formatted_value
      else
        formatted_value + currency_symbol
      end
    end

    def convert_to(new_currency: Moola::Currency)
      Moola::Exchange.convert(self, new_currency)
    end

    def zero?
      amount == 0
    end

    def negative?
      amount < 0
    end

    def abs
      Money.new(amount.abs, currency)
    end

    def cents
      amount
    end

    def to_s
      self.format
    end

    def to_f64
      amount / currency.subunit_to_unit.to_f64
    end

    def to_f32
      self.to_f64.to_f32
    end

    def to_f
      self.to_f64
    end

    def -
      Money.new(amount * -1, currency)
    end

    def ==(other)
      if other.is_a?(Money)
        (amount == other.amount && currency == other.currency) || (zero? && other.zero?)
      else
        false
      end
    end

    def <(other)
      if other.is_a?(Money) && currency == other.currency
        amount < other.amount
      else
        raise CompatabilityError.new
      end
    end

    def >(other)
      !(self < other || self == other)
    end

    def <=(other)
      self < other || self == other
    end

    def >=(other)
      self > other || self == other
    end

    def !=(other)
      !(self == other)
    end

    def +(other)
      if other.is_a?(Money)
        if currency == other.currency
          new_amount = amount + other.amount
          Money.new(new_amount, currency)
        else
          raise CompatabilityError.new("Money must have the same currency in order to be added")
        end
      else
        raise CompatabilityError.new("Money must be added to Money")
      end
    end

    def -(other)
      if other.is_a?(Money)
        if currency == other.currency
          new_amount = amount - other.amount
          Money.new(new_amount, currency)
        else
          raise CompatabilityError.new("Money must have the same currency in order to be subtracted")
        end
      else
        raise CompatabilityError.new("Money must be subtracted from Money")
      end
    end

    def *(value)
      if value.is_a?(Number)
        new_amount = (amount * value).to_i32
        Money.new(new_amount, currency)
      else
        raise CompatabilityError.new("Money can only be multiplied by a number")
      end
    end

    def /(value)
      if value.is_a?(Number)
        new_amount = Moola.clean_init_amount(amount / value)
        Money.new(new_amount, currency)
      elsif value.is_a?(Moola::Money)
        amount.to_f64 / value.amount.to_f64
      else
        raise CompatabilityError.new("Money can only be divided by a number or other Money")
      end
    end
  end
end
