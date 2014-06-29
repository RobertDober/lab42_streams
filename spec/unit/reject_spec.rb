require 'spec_helper'

describe Lab42::Stream do
  context '#reject' do 
    subject do
      described_class.iterate( 0, :succ )
        .reject(:odd?)
    end

    it 'is a stream' do
      expect( subject.drop(10).take 5 ).to eq [20, 22, 24, 26, 28]
    end
  end # context '#reject"
end # describe Lab42::Stream
