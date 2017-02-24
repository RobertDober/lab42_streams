require 'spec_helper'

describe Lab42::Stream do 
  context :finite_stream do

    it "from arrays" do
      expect(
        finite_stream(%w{a b c}).take 2
      ).to eq(%w{a b})
    end
    it "from enumerables" do
      expect(
        finite_stream(1..9).take 5
      ).to eq([*1..5])
    end
    it "from hashes" do
      expect(
        finite_stream({a: 1, b: 2}).take 5
      ).to eq([[:a, 1], [:b, 2]])
    end
    it "from Enumerators" do
      expect(
        finite_stream((1..5).to_enum).take 5
      ).to eq([*1..5])
    end
    it "from Lazy Enumerators" do
      expect(
        finite_stream((1..5).lazy).take 5
      ).to eq([*1..5])
    end

  end # context :to_stream
end # describe Lab42::Stream
