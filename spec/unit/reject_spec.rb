require 'spec_helper'

describe Lab42::Stream do
  context '#reject' do 

    context 'infinite' do 
      subject do
        described_class.iterate( 0, :succ )
        .reject(:odd?)
      end
      it 'is a stream' do
        expect( subject.drop(10).take 5 ).to eq [20, 22, 24, 26, 28]
      end
    end # context 'infinite'

    context 'finite' do 
      subject do
        finite_stream(0..9)
      end
      it 'is a finite stream' do
        expect( subject.reject(:odd?).to_a ).to eq [0, 2, 4, 6, 8]
      end
    end # context 'finite'
  end # context '#reject"

end # describe Lab42::Stream
