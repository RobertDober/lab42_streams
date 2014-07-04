require 'spec_helper'

describe Lab42::Stream do 
  context 'split_by_value' do 
    context 'empty stream' do 
      it 'returns the empty stream' do
        expect( empty_stream.split_by_value 42 ).to be_empty
      end
    end # context 'empty stream'

    context 'finite stream' do
      subject do
        finite_stream %w{a b b a b}
      end
      it "can be split by the first value" do
        expect( subject.split_by_value( "a" ).map(:to_a).to_a).to eq [
          %w{ a b b }, %w{ a b }
        ]
      end
    end # context 'finite stream'
  end # context 'split_by_value'
end # describe Lab42::Stream
