require "../../spec_helper"

describe Moola::Currency do

  describe ".lookup" do
    it "returns a Hash of currencies" do
      # this should be better
      Moola::Currency.lookup.keys.should contain("usd")
    end
  end

  describe ".all" do
    it "returns an Array of all currencies" do
      # also needs to be better
      Moola::Currency.all.size.should eq(1)
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
