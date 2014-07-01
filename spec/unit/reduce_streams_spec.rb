require 'spec_helper'

describe Lab42::Stream do
  context "reduce" do
    # Rediuction does not make sense on infinite streams, use scanning instead
    context :infinite_streams do 
    end

    context :finite_streams do 
      let(:five){ finite_stream(1..5) }
      let(:reduction){ five.reduce(:+) }
      let(:result){ 15 }
      

      it "can be reduced completely" do
        expect( reduction ).to eq( result )
      end
      it "can be injected completetly" do
        expect( five.inject(0){|a,e|a+e}).to eq( result )
      end

    end # context :finite_streams

    context :empty_stream do 
      it "can reduced to itself (Ruby's semantic)" do
        expect( empty_stream.reduce :not_even_existing ).to be_empty
      end
      it "can be injected to itself" do
        expect( empty_stream.inject [], :not_even_existing ).to be_empty
      end
    end # context :empty_stream

    context "one element stream" do 
      let(:one_element){ finite_stream [42]}
      
      it "can be reduced to itself (Ruby's semantic)" do
        expect( one_element.reduce :not_even_existing ).to eq 42
      end
    end # context "one element stream"
  end
end
      


