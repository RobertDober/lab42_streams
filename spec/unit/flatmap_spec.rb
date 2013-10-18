require 'spec_helper'
require 'lab42/core/fn'

describe Lab42::Stream do 
  context :flatmap do 
    let(:double){
      -> ele do
        finite_stream [ele, ele]
      end
    }
    it "flattens one level" do
      excpect(
        const_stream( 1..3 ).flatmap(double).to_a
      ).to eq([1,1,2,2,3,3])
    end
  end # context :flatmap

end # describe Lab42::Stream
