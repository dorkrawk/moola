# Moola
A Crystal library for dealing with money (inspired by [RubyMoney](https://github.com/RubyMoney/money))

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  grey_matter:
    github: dorkrawk/grey_matter
```

## Usage

### Basic Money object
```
money = Moola.new(42_00) # creates a new Moola::Money object
money.format # "$42.00"
money.cents  # 4200
money.zero?  # false
money.to_f # 42.0
-money == Moola.new(-42_00)
```

### Comparisons
```
Moola::Money.new(5_00) == Moola::Money.new(5_00) # true
Moola::Money.new(5_00) == Moola::Money.new(7_00) # false
Moola::Money.new(5_00, "USD") == Moola::Money.new(5_00, "EUR") # false
[Moola::Money.new(5_00), Moola::Money.new(2_00), Moola::Money.new(7_00)].sort # sorted by amount
```

### Arithmetic
```
Moola::Money.new(5_00) + Moola::Money.new(10_00) == Moola::Money.new(15_00)
Moola::Money.new(15_00) + Moola::Money.new(12_00) == Moola::Money.new(3_00)
Moola::Money.new(15_00) / 3 == Moola::Money.new(5_00)
Moola::Money.new(5_00) * 3 == Moola::Money.new(15_00)
```

### Conversion
```
Moola::Exchange.add_conversion(Moola::Currency.find("usd"), Moola::Currency.find("cad"), 1.3)
money = Moola.new(1_00, "USD")
money.convert_to(Moola::Currency.find("cad")) == Moola.new(1_30, "cad")
```

## Testing

```
# from the project root...
crystal spec
```
