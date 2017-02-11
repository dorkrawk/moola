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

  describe "#negative?" do
     it "returns true if a Money's amount is negative" do
       money = Moola::Money.new(-500)
       money.negative?.should eq(true)
     end

     it "returns true if a Money's amount is nto negative" do
       money = Moola::Money.new(500)
       money.negative?.should eq(false)
     end
  end

  describe "#to_f" do
    it "converst the amount to a Float64" do
      money = Moola::Money.new(42_99)
      money_f = money.to_f
      money_f.should eq(42.99)
      money_f.should be_a(Float64)
    end

    it "handles trailing 0s correctly" do
      money = Moola::Money.new(42_00)
      money.to_f.should eq(42.0)
    end
  end

  describe "#format" do

    it "returns a string representing the money amount" do
      money = Moola::Money.new(42_00)
      money.format.should eq("$42.00")
    end
  end

  describe "#convert_to" do

    it "converts as expected" do
      Moola::Exchange.clear_conversions
      from = Moola::Currency.find("usd")
      to = Moola::Currency.find("cad")
      rate = 1.2
      Moola::Exchange.add_conversion(from, to, rate)
      from_money = Moola::Money.new(1_00, from)
      from_money.convert_to(to).should eq Moola::Money.new(1_20, to)
    end
  end

  describe "#cents" do

    it "returns the amount for in cents for a Money" do
      money = Moola::Money.new(42_00)
      money.cents.should eq(4200)
    end
  end

  describe "#<" do
    it "can sort a list of Moneys" do
      [Moola::Money.new(500), Moola::Money.new(200), Moola::Money.new(700)].sort.should eq([Moola::Money.new(200), Moola::Money.new(500), Moola::Money.new(700)])
    end

    it "raises a CompatabilityError when compaired to a Money with different currency" do
      small_usd = Moola::Money.new(5, Moola::Currency.find("usd"))
      big_cad = Moola::Money.new(6, Moola::Currency.find("cad"))
      expect_raises(Moola::CompatabilityError) do
        (small_usd < big_cad)
      end
    end
  end

  describe "#==" do
    it "returns false when compaired to a non-Money object" do
      money = Moola::Money.new(42_00)
      (money == "$").should eq false
    end

    it "returns true when compaired to any Money.zero with different currency" do
      zero_usd = Moola::Money.new(0, Moola::Currency.find("usd"))
      zero_cad = Moola::Money.new(0, Moola::Currency.find("cad"))
      (zero_usd == zero_cad).should eq true
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
