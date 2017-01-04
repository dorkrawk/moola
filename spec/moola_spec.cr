require "./spec_helper"

describe Moola do
  describe ".new" do
    it "creates a new Molla::Money object" do
      money = Moola.new(42_00)
      money.should be_a(Moola::Money)
      money.amount.should eq(42_00)
    end

    it "creates a new Molla::Money object when passed a float" do
      money = Moola.new(42.42)
      money.should be_a(Moola::Money)
      money.amount.should eq(42_42)
    end

    it "creates a new Molla::Money object when passed a string of an int" do
      money = Moola.new("4200")
      money.should be_a(Moola::Money)
      money.amount.should eq(42_00)
    end

    it "creates a new Molla::Money object when passed a string of an float" do
      money = Moola.new("42.42")
      money.should be_a(Moola::Money)
      money.amount.should eq(42_42)
    end

    it "creates a new Moola::Money object with the Money DEFAULT_CURRENCY" do
      money = Moola.new(42.00)
      money.currency.should eq(Moola::Money::DEFAULT_CURRENCY)
    end
  end
end
