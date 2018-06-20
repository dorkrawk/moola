require "json"

module Moola
  class Currency

    CURRENCY_DATA_PATH = File.expand_path("../../../data/currencies", __FILE__)

    @@loaded_currencies = {} of String => Moola::Currency

    getter key

    JSON.mapping(
      iso_code: String,
      name: String,
      symbol: String,
      subunit: String,
      subunit_to_unit: Int32,
      symbol_first: Bool,
      decimal_mark: String,
      thousands_separator: String,
      smallest_denomination: Int32
    )

    def self.find(key : String) : Moola::Currency
      clean_key = key.downcase
      self.loaded_currencies.fetch(clean_key) do |missed_key|
        raise UnknownCurrencyError.new("Can't find currency: #{missed_key}")
      end
    end

    def self.loaded_currencies
      return @@loaded_currencies unless @@loaded_currencies.empty?
      self.load_currencies
      @@loaded_currencies
    end

    def self.all
      self.loaded_currencies.values
    end

    def self.load_currencies
      Dir.glob("#{CURRENCY_DATA_PATH}/*.json") do |file_path|
        begin
          currency_json = File.read(file_path)
          currency = Moola::Currency.from_json(currency_json)
          @@loaded_currencies[currency.iso_code.downcase] = currency
        rescue ex
          # do nothing here to allow us to move on to the next currency file
        end
      end
    end
  end
end
