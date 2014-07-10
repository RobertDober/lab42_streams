require 'spec_helper'

describe Lab42::Stream do
  context :merge_streams do 
    context :infinite_streams do 
      let(:evens){stream_by 0, :+, 2}
      let(:odds){stream_by 1, :+, 2}
      it "can be merged" do
        expect(
          merge_streams( evens, odds, evens ).take 7
        ).to eq([0,1,0, 2,3,2, 4])
      end
      
    end # context :infinite_streams

    context :finite_streams do 
      let(:three){finite_stream 1..3}
      let(:voyels){finite_stream %w[a e i o u]}
      let(:empty){empty_stream}
      let(:two){finite_stream 0..1}
      it "can be merged" do
        expect(
          merge_streams( three, voyels, empty, two ).to_a
        ).to eq([ 1, "a", 0, 2, "e", 1, 3, "i", "o", "u" ])
      end
      
    end # context :finite_streams

    context :mixed_streams do 
      it "can be merged" do
        expect(
          merge_streams( finite_stream(1..2), const_stream( "*") ).take 5
        ).to eq([1, "*", 2, "*", "*" ])
      end
    end # context :mixed_streams
    
  end # context :merge_streams

  context 'split a stream' do 
    let( :ints ){ iterate 0, :succ }
    
    context 'can be split into evens and odds' do
      let( :evens ){ ints.split_into( 2 ).first }
      let( :odds ){ ints.split_into( 2 ).last }
      
      it{ expect( evens.take(3) ).to eq [0, 2, 4] }
      it{ expect( odds.take(3) ).to eq [1, 3, 5] }
      
    end # context 'can be split into evens and odds'
      
  end # context 'split a stream'
end # describe Lab42::Stream

