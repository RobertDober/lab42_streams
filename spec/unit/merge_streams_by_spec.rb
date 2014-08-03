require 'spec_helper'

describe Lab42::Stream do
  context :merge_streams_by do 
    context :infinite_streams do 
      let(:evens){stream_by 0, :+, 2}
      let(:odds){stream_by 1, :+, 2}
      it "can be merged" do
        expect(
          merge_streams_by( evens, odds, evens, :> ).take 7
        ).to eq([1,0,0, 3,2,2, 5])
      end
      
    end # context :infinite_streams

    context :mixed_streams do
      it "can be merged" do
        expect(
          merge_streams_by( finite_stream(1..2), const_stream( 3 ), :> ).take 7
        ).to eq([3, 1, 3, 2, 3, 3, 3])
      end
      it "can be merged with a block" do
        expect(
          merge_streams_by( finite_stream(1..2), const_stream( 3 )){ |a, b| a > b }.take 7
        ).to eq([3, 1, 3, 2, 3, 3, 3])
        
      end
    end # context :mixed_streams
    
  end # context :merge_streams
end # describe Lab42::Stream

