require "../../spec_helper"

describe Moola::Currency do

  # assumes that we at least have the USD currency (usd.json) in the system

  describe ".loaded_currencies" do
    it "returns a Hash of currencies containing usd" do
      Moola::Currency.loaded_currencies.keys.should contain("usd")
    end
  end

  describe ".all" do
    it "returns an Array of all Currency objects available" do
      Moola::Currency.all.should be_a(Array(Moola::Currency))
    end
  end

  describe ".find" do
    it "returns a Currency based on the key" do
      Moola::Currency.find("usd").should be_a(Moola::Currency)
    end

    it "ignores key capitalization" do
      Moola::Currency.find("USD").should be_a(Moola::Currency)
    end

    it "raises an UnknownCurrencyError if a missing key is used" do
      expect_raises(Moola::UnknownCurrencyError) do
        Moola::Currency.find("bad_key")
      end
    end
  end
end
