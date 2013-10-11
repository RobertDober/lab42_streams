require 'spec_helper'
require 'lab42/core/fn'

describe Lab42::Stream do 
  context :filter do 
    let(:ints){stream_by(0,:+,1)}
    let(:evens){stream_by(0,:+,2)}
    let(:five_first_evens){evens.take 5}

    context "empty is empty for" do
      
      it "block" do
        expect( empty_stream.filter{} ).to be_empty
      end

      it "message" do
        expect( empty_stream.filter(:odd?) ).to be_empty
      end

      it "proc" do
        expect( empty_stream.map(sendmsg(:succ)) ).to be_empty
      end
    end # context "empty is empty for"

    context "maps ints to evens (by means of filtering)" do
      it "with block" do
        expect(
          ints.filter{ |x| x.even? }.take 5
        ).to eq( five_first_evens )
      end
      it "with symbols" do
        expect(
          ints.filter(:even?).take 5
        ).to eq( five_first_evens )
      end
      it "with lambda" do
        expect(
          ints.filter(->(x){ (x%2).zero? } ).take 5
        ).to eq( five_first_evens )
      end
    end

    context "is truley lazy" do
      let(:failing){finite_stream([1,2]) + cons_stream(3){raise RuntimeError}}
      it "fails if forced" do
        expect( ->{failing.take 4} ).to raise_error( RuntimeError )
      end
      it "does not fail if filtered" do
        expect { failing.filter( 2.fn.> ) }.not_to raise_error
      end
      it "does not fail if filtered even if the next head fails" do
        expect { failing.filter( 0.fn.> ) }.not_to raise_error
      end


      
    end # context "is truley lazy"
  end # context :map

end # describe Lab42::Stream
