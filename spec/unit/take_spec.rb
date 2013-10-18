require 'spec_helper'

describe Lab42::Stream do
  context :take do 
    context :infinite_streams do 
      let(:ints){stream_by 0, :succ}
      it "can take a finite number of ints" do
        expect(
          ints.take 5
        ).to eq([*0...5])
      end
      it "does not depend on the position" do
        expect(
          ints.drop( 5 ).take 5
        ).to eq([ *5..9] )
      end
    end # context :infinite_streams

    context :empty_streams do 
      it "can take any number" do
        expect(
          empty_stream.take 5
        ).to be_empty
      end
    end # context :empty_streams

    context :finite_streams do 
      let(:digits){finite_stream 0..9}
      it "can take an inferior number of digits" do
        expect(
          digits.take 5
        ).to eq([*0...5])
      end
      it "can take all digits" do
        expect(
          digits.take 10
        ).to eq([*0..9])
      end
      it "can take even more digits (but not getting them)" do 
        expect(
          digits.take 12
        ).to eq([*0..9])
      end
    end # context :finite_streams
  end # context :take

end # describe Lab42::Stream
