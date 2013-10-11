require 'spec_helper'

describe Lab42::Stream do 
  context :map do 
    let(:ints){stream_by(0,:+,1)}
    let(:evens){stream_by(0,:+,2)}
    let(:five_first_evens){evens.take 5}

    context "empty is empty for" do
      
      it "block" do
        expect( empty_stream.map{} ).to be_empty
      end

      it "message" do
        expect( empty_stream.map(:succ) ).to be_empty
      end

      it "proc" do
        expect( empty_stream.map(sendmsg(:succ)) ).to be_empty
      end
    end # context "empty is empty for"

    context "maps ints to evens" do
      it "with block" do
        expect(
          ints.map{ |x| 2*x }.take 5
        ).to eq( five_first_evens )
      end
      it "with symbols" do
        expect(
          ints.map(:*, 2).take 5
        ).to eq( five_first_evens )
      end
      it "with lambda" do
        expect(
          ints.map(->(x){2*x} ).take 5
        ).to eq( five_first_evens )
      end
    end
  end # context :map

end # describe Lab42::Stream
