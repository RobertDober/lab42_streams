require 'spec_helper'

describe Lab42::Stream do
  context "stream_by" do 
    let(:integers){stream_by(0,:+,1)}
    let(:ints2){ stream_by(0){|x| x.succ } }
    let(:digits){[*0..9]}

    it "defines the ints" do
      expect(integers.take 10).to eq(digits)
    end
    it "..again" do
      expect(ints2.take 10).to eq(digits)
    end

  end # context "stream_by"
end # describe Lab42::Stream
