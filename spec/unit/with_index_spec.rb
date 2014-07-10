require 'spec_helper'

describe Lab42::Stream do 
  context 'with_index' do
    context 'empty stream' do 
      it 'is empty' do
        expect( empty_stream.with_index ).to be_empty
        
      end
    end # context 'empty stream'
    context 'finite stream' do 
      it 'returns a finite indexed stream' do
        expect( finite_stream(1..2).with_index.entries ).to eq [[1,0], [2,1]]
      end
      
    end # context 'finite stream'
    context 'infinite steam' do 
      it 'returns an infinite indexed stream' do
        expect( iterate( 0, :succ ).with_index.drop(10).take 2 ).to eq [[10,10],[11,11]]
      end
    end # context 'infinite steam'

    context 'and an offset' do 
      it 'returns an indexed stream with an offset' do
        expect( finite_stream(1..2).with_index(42).entries ).to eq [[1,42], [2,43]]
      end
    end # context 'and an offset'
  end # context 'with_index'
end # describe Lab42::Stream
