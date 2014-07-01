require 'spec_helper'

describe Lab42::Stream do
  context "take_while" do 
    context :infinite_streams do 
      let(:ints){stream_by 0, :succ}
      it "can take a finite number of ints with a block" do
        expect(
          ints.take_while{ |x| x < 5 }
        ).to eq([*0..4])
      end
      it "can take a finite number of ints with a behavior" do
        expect(
          ints.take_while :<, 5
        ).to eq([*0..4])
      end
      it "does not depend on the position" do
        expect(
          ints.drop( 5 ).take_while :<, 9
        ).to eq([ *5..8] )
      end
      it "can have an empty result" do
        expect( ints.take_while :false ).to be_empty
      end
    end # context :infinite_streams

    context :empty_streams do 
      it "can take any number" do
        expect(
          empty_stream.take_while :true
        ).to be_empty
      end
    end # context :empty_streams

    context :finite_streams do 
      let(:digits){finite_stream 0..9}
      it "can take an inferior number of digits with a proc" do
        expect(
          digits.take_while ->(x){ x < 6 } 
        ).to eq([*0..5])
      end
      it "can take all digits" do
        expect(
          digits.take_while :true
        ).to eq([*0..9])
      end
    end # context :finite_streams
  end # context :take

end # describe Lab42::Stream
