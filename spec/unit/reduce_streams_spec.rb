require 'spec_helper'

describe Lab42::Stream do
  context :reduce_streams do 
    context :infinite_streams do 
      let(:ones){const_stream 1}
      it 'can be reduced with + to count' do
        expect( ones.reduce_stream(:+).take 5 ).to eq([*2..6]) 
      end
      it 'can be injected with + and an initial value' do
        expect( ones.inject_stream(0, :+).take 5 ).to eq([*1..5]) 
      end
    end

    context :finite_streams do 
    end # context :finite_streams
  end
end
      


