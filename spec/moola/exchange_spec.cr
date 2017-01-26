require "../../spec_helper"

describe Moola::Exchange do

  describe "self.add_conversion" do

    it "adds a conversion to the conversions" do
      Moola::Exchange.clear_conversions
      from = Moola::Currency.find("usd")
      to = Moola::Currency.find("cad")
      rate = 1.2
      Moola::Exchange.add_conversion(from, to, rate)
      Moola::Exchange.conversions[from][to].should eq rate
    end

    it "adds multiple conversions" do
      Moola::Exchange.clear_conversions
      from1 = Moola::Currency.find("usd")
      to1 = Moola::Currency.find("cad")
      rate1 = 1.2
      from2 = Moola::Currency.find("eur")
      to2 = Moola::Currency.find("gbp")
      rate2 = 2.2
      Moola::Exchange.add_conversion(from1, to1, rate1)
      Moola::Exchange.conversions[from1][to1].should eq rate1
      Moola::Exchange.add_conversion(from2, to2, rate2)
      Moola::Exchange.conversions[from2][to2].should eq rate2
    end

    it "adds additional conversions" do
      Moola::Exchange.clear_conversions
      from1 = Moola::Currency.find("usd")
      to1 = Moola::Currency.find("cad")
      rate1 = 1.2
      from2 = Moola::Currency.find("usd")
      to2 = Moola::Currency.find("gbp")
      rate2 = 2.2
      Moola::Exchange.add_conversion(from1, to1, rate1)
      Moola::Exchange.conversions[from1][to1].should eq rate1
      Moola::Exchange.add_conversion(from2, to2, rate2)
      Moola::Exchange.conversions[from1][to2].should eq rate2
    end
  end

  describe ".conversion_exists?" do

    it "returns true if a conversion exists in @@conversions" do
      Moola::Exchange.clear_conversions
      from = Moola::Currency.find("usd")
      to = Moola::Currency.find("cad")
      rate = 1.2
      Moola::Exchange.add_conversion(from, to, rate)
      Moola::Exchange.conversion_exists?(from, to).should eq true
    end

    it "returns false if a conversion does not exist in @@conversions" do
      Moola::Exchange.clear_conversions
      from = Moola::Currency.find("usd")
      to = Moola::Currency.find("cad")
      Moola::Exchange.conversion_exists?(from, to).should eq false
    end
  end

  describe ".convert" do

    it "returns a Money object with an amount equal to the converted amount" do
      Moola::Exchange.clear_conversions
      from = Moola::Currency.find("usd")
      to = Moola::Currency.find("cad")
      rate = 1.2
      Moola::Exchange.add_conversion(from, to, rate)
      from_money = Moola::Money.new(1_00, from)
      Moola::Exchange.convert(from_money, to).should eq Moola::Money.new(1_20, to)
    end

    it "throw an UnavailableConversionError if no conversion is available" do
      Moola::Exchange.clear_conversions
      from = Moola::Currency.find("usd")
      to = Moola::Currency.find("cad")
      from_money = Moola::Money.new(1_00, from)
      expect_raises(Moola::UnavailableConversionError) do
        Moola::Exchange.convert(from_money, to)
      end
    end
  end
end
