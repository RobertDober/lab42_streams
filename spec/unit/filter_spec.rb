require 'spec_helper'
require 'lab42/core/fn'

describe Lab42::Stream do 
  context :filter do
    let(:ints){stream_by(0,:+,1)}
    let(:evens){stream_by(0,:+,2)}
    let(:five_first_evens){evens.take 5}

    context "empty is empty for, :wip" do
      
      it "block" do
        expect( empty_stream.filter{} ).to be_empty
      end

      it "message" do
        expect( empty_stream.filter(:odd?) ).to be_empty
      end

      it "proc" do
        expect( empty_stream.map(:succ.to_proc) ).to be_empty
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
  end # context :filter

  context "long tail recursion problem" do 
    let(:ints){stream_by(0,:+,1)}
    it "is lazy even if the predicate does not apply", :slow do
      expect( ints.filter(:>, 1_000_000).head ).to eq 1_000_001
    end
    it "still terminates on empty" do
      expect( finite_stream(1..10).filter(:>, 10) ).to be_empty
    end
  end # context "long tail recursion problem"
end # describe Lab42::Stream
