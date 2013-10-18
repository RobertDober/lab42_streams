require 'spec_helper'
require 'lab42/core/fn'

describe Lab42::Stream do 
  context :flatmap do
    let(:doubler){
      -> ele do
        finite_stream [ele, ele]
      end
    }
    let(:doubled){[1,1,2,2,3,3]}
    it "flattens one level" do
      expect(
        finite_stream( 1..3 ).flatmap(doubler).to_a
      ).to eq(doubled)
    end
    it "uses a minimal protocol on the result of the operation" do
      expect(
        flatmap( finite_stream( 1..3 ) ){ |e| finite_stream [e, e] }.to_a
      ).to eq( doubled )
    end
  end # context :flatmap

end # describe Lab42::Stream
