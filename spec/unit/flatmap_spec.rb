require 'spec_helper'
require 'lab42/core/fn'

describe Lab42::Stream do 
  context :flatmap do
    let(:tripler){
      -> ele do
        finite_stream [ele, ele, ele]
      end
    }
    let(:tripled){[1,1,1,2,2,2,3,3,3]}
    let(:ts){finite_stream( 1..3 ).flatmap( tripler )}

    it "flattens one level" do
      expect(
        ts.to_a
      ).to eq(tripled)
    end

    it "REGRESSION:can be forced many times" do
      3.times do
        expect( ts.to_a ).to eq tripled
      end
    end
  end # context :flatmap


end # describe Lab42::Stream
