require 'spec_helper'
require 'lab42/core/fn'

describe Lab42::Stream do

  let(:ints){cons_stream(0){combine_streams ints, const_stream(1), Integer.fm.+}}

  context "reduce_while" do 
    it "reduces while a condition is true" do
      expect(
        ints.reduce_while(55.fn.>){ |a,e| a + e }
      ).to eq( 45 )
    end
    it "raises a constraint error if it cannot reduce" do
      expect{
        ints.reduce_while(0.fn.>, Integer.fm.+)
      }.to raise_error(Lab42::Stream::ConstraintError)
    end
    it "can run to the end of a stream" do
      expect(
        finite_stream(1..10).reduce_while(->(*a){true}, Integer.fm.+)
      ).to equal( 55 )
    end

  end # context "reduce_while"
end # describe Lab42::Stream
