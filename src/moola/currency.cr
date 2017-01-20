module Moola
  class Currency

    @@lookup = {} of String => Moola::Currency

    getter key

    def initialize(@key : String)

    end

    def name
      key
    end

    def self.find(key : String) : Moola::Currency
      clean_key = key.downcase
      self.lookup.fetch(clean_key) do |missed_key|
        raise UnknownCurrencyError.new("Can't find currency: #{missed_key}")
      end
    end

    def self.lookup
      found_lookup = @@lookup
      return found_lookup unless found_lookup.empty?
      @@lookup = self.load_currencies
      @@lookup
    end

    def self.all
      self.lookup.values
    end

    def self.load_currencies
      {"usd" => self.new("usd")}
    end
  end
end
