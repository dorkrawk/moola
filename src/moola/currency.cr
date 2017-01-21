require "json"

module Moola
  class Currency

    CURRENCY_DATA_PATH = File.expand_path("../../../data/currencies", __FILE__)
    CURRENCY_DATA_FILENAME = "usd.json"


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
      Dir.foreach(CURRENCY_DATA_PATH) do |currency_file|
        file_path = "#{CURRENCY_DATA_PATH}/#{currency_file}"
        if File.file?(file_path)
          currency_json = File.read(file_path)
          @@loaded_currencies["usd"] = Moola::Currency.from_json(currency_json)
        end
      end
    end
  end
end
