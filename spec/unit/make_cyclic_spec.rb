require 'spec_helper'

describe Lab42::Stream do
  context :make_cyclic do 
    context :empty do 
      it "is still empty" do
        empty_stream.make_cyclic.should be_empty
      end
    end # context :empty

    context :non_empty do 
      it "cylces for one" do
        expect(
          finite_stream( [1] ).make_cyclic.drop( 5 ).take( 3 )
        ).to eq([1,1,1])
      end
      it "cylces for some" do
        expect(
          finite_stream( [1,2,3] ).make_cyclic.drop( 5 ).take( 5 )
        ).to eq([3,1,2,3,1])
      end
    end # context :non_empty
  end # context :make_cyclic
end # describe Lab42::Stream
