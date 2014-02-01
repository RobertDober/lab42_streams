require 'spec_helper'

describe Lab42::Stream do
  context :reduce_streams do 
    context :infinite_streams do 
      let(:ones){const_stream 1}
      it 'can be reduced with + to count' do
        expect( ones.reduce_stream(:+).take 5 ).to eq([*2..6]) 
      end
      it 'can be injected with + and an initial value' do
        expect( ones.inject_stream(10, :+).take 5 ).to eq([*11..15]) 
      end
    end

    context :finite_streams do 
      let(:five){ finite_stream(1..5) }
      let(:reduction){ five.reduce_stream(:+) }
      let(:result){[3,6,10,15]}
      

      it "can be reduced completely" do
        expect( reduction.to_a ).to eq( result )
      end
      it "can be injected completetly" do
        expect( five.inject_stream(0){|a,e|a+e}.to_a).to eq( [1,3,6,10,15] )
      end

      it "supports overtaking ;)" do
        expect( reduction.take 10 ).to eq( result )
      end

      it "suppors overdropping" do
        expect( reduction.drop 10 ).to be_empty
      end
    end # context :finite_streams

    context :empty_stream do 
      it "can be reduced to itself" do
        expect( empty_stream.reduce_stream :not_even_existing ).to be_empty
      end
      it "can be injected to itself" do
        expect( empty_stream.inject_stream [], :not_even_existing ).to be_empty
      end
    end # context :empty_stream
  end
end
      


