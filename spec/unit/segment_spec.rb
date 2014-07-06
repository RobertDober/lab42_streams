require 'spec_helper'

describe Lab42::Stream do 
  context 'segment' do 
    context 'empty stream' do 
      it 'returns the empty stream' do
        expect( empty_stream.segment :==, 42 ).to be_empty
      end
    end # context 'empty stream'

    context 'finite streams' do
      subject do
        finite_stream %w{a b b a b}
      end
      it "can be split by the first value" do
        expect( subject.segment( :==, "a" ).map(:to_a).to_a).to eq [
          %w{ a b b }, %w{ a b }
        ]
      end
    end # context 'finite stream'
  end # context 'split_by_value'

  context 'infinite streams' do 
    let(:ints){iterate 0, :succ}
    
    it 'can be segmented into some parts' do
      threes = ints.segment{ |n| n % 3 == 1 }
      expect(
        threes.take( 4 ).map( &:to_a )
      ).to eq [ [0], [1, 2, 3], [4, 5, 6], [7, 8, 9] ]
    end

  end # context 'infinite streams'
end # describe Lab42::Stream
