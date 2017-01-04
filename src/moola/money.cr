module Moola
  class Money
    DEFAULT_CURRENCY = "USD"

    getter amount, currency

    def initialize(@amount : Int32, @currency : String = DEFAULT_CURRENCY)
    end

    def format
      # this is a bad implementation, need to build Moola::Currency class
      amount_str = amount.to_s
      unit_str = amount_str[0, amount_str.size - 2]
      subunit_str = amount_str[amount_str.size - 2, amount_str.size]
      "$#{unit_str}.#{subunit_str}"
    end

    def zero?
      amount == 0
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
