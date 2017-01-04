require "../../spec_helper"

describe Moola::Money do

  describe "#zero?" do

    it "returns true if a Money's amount is 0" do
      money = Moola::Money.new(0)
      money.zero?.should eq(true)
    end

    it "returns false if Money is not 0" do
      money = Moola::Money.new(42_00)
      money.zero?.should eq(false)
    end
  end

  describe "#format" do

    it "returns a string representing the money amount" do
      money = Moola::Money.new(42_00)
      money.format.should eq("$42.00")
    end
  end

  describe "#-" do

    it "returns a Money with the negative amount" do
      money = Moola::Money.new(42_00)
      neg_money = -money
      neg_money.amount.should eq(-4200)
    end
  end

  describe "#+" do

    it "addes two Moneys together" do
      money_sum = Moola::Money.new(5_00) + Moola::Money.new(10_00)
      money_sum.amount.should eq(15_00)
    end
  end

  describe "#-" do

    it "subtracts two Moneys" do
      money_diff = Moola::Money.new(10_00) - Moola::Money.new(2_00)
      money_diff.amount.should eq(8_00)
    end
  end

  describe "#*" do

    it "multiplies Money" do
      money_prod = Moola::Money.new(10_00) * 3
      money_prod.amount.should eq(30_00)
    end

    it "multiplies Money by float" do
      money_prod = Moola::Money.new(10_00) * 1.25
      money_prod.amount.should eq(12_50)
    end
  end

  describe "#*" do

    it "divides Money by value" do
      money_div = Moola::Money.new(10_00) / 2
      money_div.amount.should eq(5_00)
    end

    it "divides Money by value" do
      money_div = Moola::Money.new(10_00) / 3
      money_div.amount.should eq(3_33)
    end

    it "divides two Moneys" do
      money_div = Moola::Money.new(10_00) / Moola::Money.new(5_00)
      money_div.should eq(2)
    end
  end
end
