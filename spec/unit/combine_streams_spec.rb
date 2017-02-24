require 'spec_helper'
  

RSpec.describe Lab42::Stream do

    let(:integers){ iterate 0, :succ }
    let(:digits)  {finite_stream 0..9}

    let( :adder ){
      -> *args do
        args.inject 0, :+
      end
    }
    

    context 'needs a stream param' do 
      it{ expect{ digits.combine_streams }.to raise_error(ArgumentError, %r{\AMissing stream parameters}) }
    end

    context :combine_streams do
      it "works with itself" do
        expect( combine_streams(digits, digits, :+).drop(6).take(5) ).to eq [12, 14, 16, 18]
      end

      it "works with others" do
        expect( combine_streams(digits, integers, :+).drop(6).take(5) ).to eq [12, 14, 16, 18]
      end

      it "combination's arity > 2" do
        expect( combine_streams(digits, digits, digits){ |a, b, c| a + b + c }.take(3) ).to eq [0, 3, 6]
      end
    end
  
end
