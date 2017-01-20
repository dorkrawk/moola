# Moola
A Crystal library for dealing with money (inspired by [RubyMoney](https://github.com/RubyMoney/money))

## Usage

### Basic Money object
```
money = Moola::Money.new(42_00)
money.format # "$42.00"
money.cents  # 4200
money.zero?  # false
-money == Moola::Money.new(-42_00)
```

### Comparisons
```
Moola::Money.new(5_00) == Moola::Money.new(5_00) # true
Moola::Money.new(5_00) == Moola::Money.new(7_00) # false
Moola::Money.new(5_00, "USD") == Moola::Money.new(5_00, "EUR") # false
```

### Arithmatic
```
Moola::Money.new(5_00) + Moola::Money.new(10_00) == Moola::Money.new(15_00)
Moola::Money.new(15_00) + Moola::Money.new(12_00) == Moola::Money.new(3_00)
Moola::Money.new(15_00) / 3 == Moola::Money.new(5_00)
Moola::Money.new(5_00) * 3 == Moola::Money.new(15_00)
```

## Testing

```
# from the project root...
crystal spec
```
